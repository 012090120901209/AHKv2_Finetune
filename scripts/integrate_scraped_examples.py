#!/usr/bin/env python3
"""
Integrate scraped example metadata with existing AHK v2 examples.

This script:
1. Loads scraped examples from JSON
2. Catalogs existing examples in the repository
3. Creates a unified metadata database
4. Generates enriched CSV for dataset building
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Set, Optional
from dataclasses import dataclass, asdict
import hashlib
import csv


@dataclass
class ExampleMetadata:
    """Metadata for a single AHK v2 example."""
    filename: str
    title: str
    category: str
    source_url: Optional[str]
    description: str
    v2_verified: bool
    library_dependencies: List[str]
    code_hash: str
    file_size: int
    line_count: int


class ExampleIntegrator:
    """Integrates scraped examples with repository examples."""

    def __init__(self, repo_root: Path):
        self.repo_root = repo_root
        self.examples_dir = repo_root / "data/raw_scripts/AHK_v2_Examples"
        self.scraped_json = Path("/tmp/ahkv2_scraped_examples.json")
        self.output_catalog = repo_root / "data/examples_catalog.json"
        self.output_csv = repo_root / "data/examples_metadata.csv"

    def load_scraped_data(self) -> List[Dict]:
        """Load scraped examples from JSON."""
        if not self.scraped_json.exists():
            print(f"Warning: {self.scraped_json} not found")
            return []

        with open(self.scraped_json, 'r', encoding='utf-8') as f:
            return json.load(f)

    def extract_metadata_from_code(self, code: str) -> Dict[str, any]:
        """Extract metadata from AHK code."""
        lines = code.split('\n')
        metadata = {
            'title': '',
            'category': 'Uncategorized',
            'description': '',
            'library_dependencies': []
        }

        # Extract from header comments
        for line in lines[:20]:  # Check first 20 lines
            line = line.strip()
            if line.startswith('; Title:'):
                metadata['title'] = line.replace('; Title:', '').strip()
            elif line.startswith('; Category:'):
                metadata['category'] = line.replace('; Category:', '').strip()
            elif line.startswith('; Description:'):
                metadata['description'] = line.replace('; Description:', '').strip()
            elif line.startswith('; Library:'):
                lib = line.replace('; Library:', '').strip()
                if lib:
                    metadata['library_dependencies'].append(lib)

        # Extract #Include dependencies
        include_pattern = re.compile(r'^\s*#Include\s+<([^>]+)>', re.IGNORECASE)
        for line in lines:
            match = include_pattern.match(line)
            if match:
                lib = match.group(1)
                if lib not in metadata['library_dependencies']:
                    metadata['library_dependencies'].append(lib)

        return metadata

    def analyze_file(self, file_path: Path) -> ExampleMetadata:
        """Analyze a single .ahk file and extract metadata."""
        try:
            code = file_path.read_text(encoding='utf-8')
        except UnicodeDecodeError:
            code = file_path.read_text(encoding='utf-8-sig')

        # Calculate hash
        code_hash = hashlib.sha256(code.encode('utf-8')).hexdigest()[:16]

        # Extract metadata from code
        metadata = self.extract_metadata_from_code(code)

        # Check for v2 verification
        v2_verified = '#Requires AutoHotkey v2' in code

        return ExampleMetadata(
            filename=file_path.name,
            title=metadata['title'] or file_path.stem.replace('_', ' '),
            category=metadata['category'],
            source_url=None,  # Will be enriched if found in scraped data
            description=metadata['description'],
            v2_verified=v2_verified,
            library_dependencies=metadata['library_dependencies'],
            code_hash=code_hash,
            file_size=file_path.stat().st_size,
            line_count=len(code.split('\n'))
        )

    def catalog_existing_examples(self) -> Dict[str, ExampleMetadata]:
        """Catalog all existing examples in the repository."""
        catalog = {}

        if not self.examples_dir.exists():
            print(f"Warning: {self.examples_dir} not found")
            return catalog

        for ahk_file in sorted(self.examples_dir.glob("*.ahk")):
            metadata = self.analyze_file(ahk_file)
            catalog[ahk_file.name] = metadata

        return catalog

    def enrich_with_scraped_data(self, catalog: Dict[str, ExampleMetadata],
                                 scraped_data: List[Dict]) -> Dict[str, ExampleMetadata]:
        """Enrich catalog with scraped metadata by matching code hashes."""
        # Create hash lookup for scraped data
        scraped_by_hash = {}
        for item in scraped_data:
            code = item.get('code', '')
            code_hash = hashlib.sha256(code.encode('utf-8')).hexdigest()[:16]
            scraped_by_hash[code_hash] = item

        # Enrich catalog
        enriched = 0
        for filename, metadata in catalog.items():
            if metadata.code_hash in scraped_by_hash:
                scraped = scraped_by_hash[metadata.code_hash]
                metadata.source_url = scraped.get('source_url')
                enriched += 1

        print(f"Enriched {enriched}/{len(catalog)} examples with source URLs")
        return catalog

    def generate_reports(self, catalog: Dict[str, ExampleMetadata]):
        """Generate catalog JSON and CSV reports."""
        # Convert to serializable format
        catalog_data = {
            'generated': '2025-11-20',
            'total_examples': len(catalog),
            'v2_verified': sum(1 for m in catalog.values() if m.v2_verified),
            'with_source_urls': sum(1 for m in catalog.values() if m.source_url),
            'categories': self._count_by_category(catalog),
            'examples': {k: asdict(v) for k, v in catalog.items()}
        }

        # Write JSON catalog
        with open(self.output_catalog, 'w', encoding='utf-8') as f:
            json.dump(catalog_data, f, indent=2, ensure_ascii=False)
        print(f"Created catalog: {self.output_catalog}")

        # Write CSV metadata
        with open(self.output_csv, 'w', encoding='utf-8', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=[
                'filename', 'title', 'category', 'source_url', 'description',
                'v2_verified', 'library_count', 'libraries', 'code_hash',
                'file_size', 'line_count'
            ])
            writer.writeheader()

            for metadata in sorted(catalog.values(), key=lambda m: m.filename):
                writer.writerow({
                    'filename': metadata.filename,
                    'title': metadata.title,
                    'category': metadata.category,
                    'source_url': metadata.source_url or '',
                    'description': metadata.description,
                    'v2_verified': metadata.v2_verified,
                    'library_count': len(metadata.library_dependencies),
                    'libraries': ', '.join(metadata.library_dependencies),
                    'code_hash': metadata.code_hash,
                    'file_size': metadata.file_size,
                    'line_count': metadata.line_count
                })

        print(f"Created CSV metadata: {self.output_csv}")

    def _count_by_category(self, catalog: Dict[str, ExampleMetadata]) -> Dict[str, int]:
        """Count examples by category."""
        counts = {}
        for metadata in catalog.values():
            category = metadata.category
            counts[category] = counts.get(category, 0) + 1
        return dict(sorted(counts.items(), key=lambda x: x[1], reverse=True))

    def print_summary(self, catalog: Dict[str, ExampleMetadata]):
        """Print integration summary."""
        total = len(catalog)
        v2_verified = sum(1 for m in catalog.values() if m.v2_verified)
        with_urls = sum(1 for m in catalog.values() if m.source_url)
        with_libs = sum(1 for m in catalog.values() if m.library_dependencies)

        categories = self._count_by_category(catalog)

        print("\n" + "="*60)
        print("EXAMPLE CATALOG SUMMARY")
        print("="*60)
        print(f"Total examples: {total}")
        print(f"V2 verified: {v2_verified} ({v2_verified/total*100:.1f}%)")
        print(f"With source URLs: {with_urls} ({with_urls/total*100:.1f}%)")
        print(f"With library dependencies: {with_libs} ({with_libs/total*100:.1f}%)")
        print(f"\nTop categories:")
        for i, (cat, count) in enumerate(list(categories.items())[:10], 1):
            print(f"  {i}. {cat}: {count}")
        print("="*60 + "\n")

    def run(self):
        """Execute the integration process."""
        print("Starting example integration...\n")

        # Load scraped data
        print("Loading scraped examples...")
        scraped_data = self.load_scraped_data()
        print(f"Loaded {len(scraped_data)} scraped examples\n")

        # Catalog existing examples
        print("Cataloging existing examples...")
        catalog = self.catalog_existing_examples()
        print(f"Cataloged {len(catalog)} existing examples\n")

        # Enrich with scraped data
        if scraped_data:
            print("Enriching catalog with scraped metadata...")
            catalog = self.enrich_with_scraped_data(catalog, scraped_data)
            print()

        # Generate reports
        print("Generating reports...")
        self.generate_reports(catalog)

        # Print summary
        self.print_summary(catalog)


def main():
    """Main entry point."""
    repo_root = Path(__file__).parent.parent
    integrator = ExampleIntegrator(repo_root)
    integrator.run()


if __name__ == "__main__":
    main()
