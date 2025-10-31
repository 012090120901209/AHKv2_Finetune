import os
import json
import argparse
from dataclasses import dataclass
from typing import Optional
from datasets import load_dataset
from transformers import AutoTokenizer
from trl import SFTConfig, SFTTrainer


from unsloth import FastLanguageModel


@dataclass
class Cfg:
    base_model: str
    max_seq_length: int
    load_in_4bit: bool
    bf16: bool
    lora: dict
    train: dict
    merge: dict


def load_cfg(path: str) -> Cfg:
    import yaml
    with open(path, "r", encoding="utf-8") as f:
        return Cfg(**yaml.safe_load(f))


def render_harmony(tokenizer, messages):
    text = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=False,
    )
    return {"text": text}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", required=True)
    ap.add_argument("--max_steps", type=int, default=None)
    ap.add_argument("--merge_only", type=int, default=0)
    args = ap.parse_args()

    cfg = load_cfg(args.config)

    tokenizer = AutoTokenizer.from_pretrained(cfg.base_model, use_fast=True)

    model, tokenizer = FastLanguageModel.from_pretrained(
        model_name=cfg.base_model,
        max_seq_length=cfg.max_seq_length,
        load_in_4bit=cfg.load_in_4bit,
        dtype=None if cfg.bf16 else None,
    )

    if not args.merge_only:
        model = FastLanguageModel.get_peft_model(
            model,
            r=cfg.lora["r"],
            target_modules=cfg.lora["target_modules"],
            lora_alpha=cfg.lora["alpha"],
            lora_dropout=cfg.lora["dropout"],
            use_gradient_checkpointing="unsloth",
            random_state=cfg.train.get("seed", 3407),
        )

        ds = load_dataset("json", data_files=cfg.train["dataset_path"])["train"]
        def map_fn(batch):
            out = {"text": []}
            for messages in batch["messages"]:
                out["text"].append(
                    tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=False)
                )
            return out


        ds = ds.map(map_fn, batched=True, remove_columns=ds.column_names)


        train_args = SFTConfig(
            per_device_train_batch_size=cfg.train["per_device_train_batch_size"],
            gradient_accumulation_steps=cfg.train["gradient_accumulation_steps"],
            learning_rate=cfg.train["learning_rate"],
            weight_decay=cfg.train["weight_decay"],
            warmup_ratio=cfg.train["warmup_ratio"],
            logging_steps=cfg.train["logging_steps"],
            save_steps=cfg.train["save_steps"],
            output_dir=cfg.train["output_dir"],
            num_train_epochs=cfg.train["num_train_epochs"],
            max_steps=args.max_steps if args.max_steps else cfg.train.get("max_steps"),
            optim="adamw_8bit",
            report_to="none",
            seed=cfg.train["seed"],
        )


        trainer = SFTTrainer(
            model=model,
            tokenizer=tokenizer,
            train_dataset=ds,
            args=train_args,
        )
        trainer.train()


    # Merge LoRA adapters into full weights
    out_dir = cfg.merge["out_dir"]
    save_method = cfg.merge.get("save_method", "bf16")
    model.save_pretrained_merged(out_dir, tokenizer, save_method=save_method)


if __name__ == "__main__":
    main()

