# AHK File Formatting Specification

## Overview

This specification outlines a comprehensive method for checking and validating AutoHotkey (AHK) file formatting. The checks cover indentation, line endings, comment formatting, basic syntax validation, and structural elements. The goal is to ensure consistent, readable, and maintainable AHK code.

## 1. Indentation Check

### Criteria
- **Consistency**: All indentation within a file must use either tabs or spaces exclusively. Mixed usage is not allowed.
- **Standard**: Recommend 4 spaces per indentation level. Tabs should be converted to 4 spaces if spaces are used.
- **Detection**: Scan each line for leading whitespace. Count spaces or detect tab characters.
- **Validation**:
  - If first indented line uses spaces, all subsequent indented lines must use spaces.
  - If first indented line uses tabs, all must use tabs.
  - Indentation levels must be multiples of the base unit (4 spaces or 1 tab).

### Common Issues and Resolution
- **Mixed indentation**: Replace all tabs with spaces or vice versa.
- **Inconsistent spacing**: Normalize to 4 spaces per level.
- **Auto-fix**: Use regex replacement to standardize indentation.

## 2. Line Endings Check

### Criteria
- **Detection**: Identify line endings as CRLF (`\r\n`) or LF (`\n`).
- **Consistency**: All lines in a file must use the same line ending type.
- **Standard**: Recommend CRLF for Windows compatibility, as AHK primarily runs on Windows.

### Common Issues and Resolution
- **Mixed endings**: Convert all to CRLF using text editor tools.
- **Unix-style (LF)**: Convert to CRLF if targeting Windows.
- **Auto-fix**: Use tools like `dos2unix` or editor commands to standardize.

## 3. Comment Formatting Check

### Single-Line Comments
- **Syntax**: Use `;` for single-line comments.
- **Placement**: Comments can start at the beginning of a line or after code, with at least one space before `;`.
- **Spacing**: One space after `;` if the comment continues.
- **Examples**:
  ```ahk
  ; This is a comment
  MsgBox("Hello") ; This is an inline comment
  ```

### Multi-Line Comments
- **Syntax**: Use `/* */` for multi-line comments.
- **Formatting**: Opening `/*` on its own line, closing `*/` on its own line. Content indented to match surrounding code.
- **Documentation**: For function/class docs, use `/** */` with JSDoc-like format.
- **Examples**:
  ```ahk
  /**
   * Function description
   * @param param Description
   */
  functionName(param) {
      /* Multi-line
         comment */
  }
  ```

### Validation
- Ensure no trailing comments without proper spacing.
- Check for balanced `/* */` pairs.
- Verify documentation comments are properly formatted.

### Common Issues and Resolution
- **Missing spaces**: Add space after `;`.
- **Unbalanced multi-line**: Fix by adding missing `*/` or `/*`.
- **Auto-fix**: Use regex to insert spaces or balance pairs.

## 4. Basic Syntax Validation

### Balanced Delimiters
- **Braces `{}`**: Must be balanced. Each opening `{` must have a corresponding closing `}`.
- **Parentheses `()`**: Balanced pairs required.
- **Brackets `[]`: Balanced for arrays/objects.
- **Detection**: Use a stack-based parser to track opening/closing pairs.

### Validation Rules
- No unmatched delimiters.
- Proper nesting: Braces inside functions, etc.
- No syntax errors that prevent parsing.

### Common Issues and Resolution
- **Unmatched brace**: Add missing `}` or `{`.
- **Extra parenthesis**: Remove or add to balance.
- **Auto-fix**: Use AHK parser or linter to identify and suggest fixes.

## 5. Structural Elements Check

### Function Definitions
- **Syntax**: `functionName(parameters) {`
- **Formatting**:
  - Function name in camelCase or PascalCase.
  - Parameters separated by commas, spaces after commas.
  - Opening brace on same line as function header.
  - Body indented by 4 spaces.
  - Closing brace on new line, aligned with function start.
- **Examples**:
  ```ahk
  myFunction(param1, param2) {
      ; body
  }
  ```

### Class Declarations
- **Syntax**: `class ClassName {`
- **Formatting**:
  - Class name in PascalCase.
  - Opening brace on same line.
  - Methods indented inside class.
  - Properties and methods follow function formatting.
- **Examples**:
  ```ahk
  class MyClass {
      __New() {
          ; constructor
      }
      
      methodName() {
          ; method
      }
  }
  ```

### Validation
- Check for proper indentation within structures.
- Ensure braces are balanced and properly placed.
- Verify naming conventions (optional, but recommended).

### Common Issues and Resolution
- **Misaligned braces**: Align closing brace with class/function start.
- **Incorrect indentation**: Fix to 4 spaces.
- **Auto-fix**: Use code formatter tools.

## 6. Error Handling and Common Issue Resolution

### General Approach
- **Reporting**: Collect all errors with line numbers and descriptions.
- **Severity Levels**: Warning (style), Error (syntax).
- **Auto-fixing**: Provide automated fixes where possible.

### Common Issues
- **Indentation errors**: Auto-convert tabs to spaces or normalize spacing.
- **Line ending inconsistencies**: Convert to CRLF.
- **Comment spacing**: Insert missing spaces.
- **Syntax errors**: Suggest fixes for unbalanced delimiters.
- **Structural misalignment**: Re-indent code blocks.

### Tools and Implementation
- **Parser**: Use a custom AHK parser or regex-based checks.
- **Integration**: Can be implemented as a VSCode extension, CLI tool, or script.
- **Configuration**: Allow user preferences for tabs vs spaces, line endings.

## Implementation Notes

- **Order of Checks**: Run syntax validation first, then formatting checks.
- **Performance**: Process files line-by-line for large files.
- **Extensibility**: Add more checks for advanced AHK features (hotkeys, directives).
- **Testing**: Validate against sample AHK files from the project repository.

This specification provides a foundation for automated AHK code formatting validation and correction.