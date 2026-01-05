import gradio as gr
import json
import os

# Configuration
DATA_PATH = "data/samples.jsonl"
GRADES_PATH = "data/graded_samples.jsonl"

def load_data():
    if not os.path.exists(DATA_PATH):
        return []
    with open(DATA_PATH, "r", encoding="utf-8") as f:
        return [json.loads(line) for line in f if line.strip()]

def load_existing_grades():
    if not os.path.exists(GRADES_PATH):
        return {}
    grades = {}
    with open(GRADES_PATH, "r", encoding="utf-8") as f:
        for line in f:
            try:
                item = json.loads(line)
                grades[item["prompt"]] = item["grade"]
            except:
                continue
    return grades

# Global state
data = load_data()
grades = load_existing_grades()

def get_example(idx):
    if not data:
        return "No data found", "Please ensure data/samples.jsonl exists.", "N/A", idx
    idx = max(0, min(int(idx), len(data) - 1))
    item = data[idx]
    grade = grades.get(item["prompt"], "Not Graded")
    return item["prompt"], item["response"], f"Grade: {grade}", idx

def save_grade(idx, grade_val):
    if not data: return get_example(idx)
    item = data[idx]
    grades[item["prompt"]] = grade_val
    
    # Save all grades back to JSONL
    with open(GRADES_PATH, "w", encoding="utf-8") as f:
        for prompt, g in grades.items():
            # Find the original response
            orig_resp = next((d["response"] for d in data if d["prompt"] == prompt), "")
            f.write(json.dumps({"prompt": prompt, "response": orig_resp, "grade": g}) + "\n")
            
    return get_example(idx)

# UI Definition
with gr.Blocks(theme=gr.themes.Soft(), title="AHK v2 Finetune Grader") as demo:
    gr.Markdown("# 🤖 AHK v2 Finetune Grader")
    gr.Markdown("Review and curate your synthetic dataset for better fine-tuning results.")
    
    with gr.Row():
        with gr.Column(scale=2):
            prompt_display = gr.Textbox(label="Prompt (Input)", lines=4, interactive=False)
            response_display = gr.Code(label="Response (Output)", language="autohotkey", lines=10, interactive=False)
        with gr.Column(scale=1):
            status_label = gr.Label(value="Status: Ready")
            grade_display = gr.Markdown("### Grade: Not Graded")
            index_num = gr.Number(value=0, label="Current Index", precision=0)
            progress_bar = gr.Markdown(f"Total Examples: {len(data)}")

    with gr.Row():
        btn_good = gr.Button("✅ Mark Good", variant="primary")
        btn_bad = gr.Button("❌ Mark Bad", variant="stop")
    
    with gr.Row():
        btn_prev = gr.Button("⬅️ Previous")
        btn_next = gr.Button("Next ➡️")

    # Logic
    def update_ui(idx):
        p, r, g_text, actual_idx = get_example(idx)
        return p, r, g_text, actual_idx

    demo.load(fn=update_ui, inputs=index_num, outputs=[prompt_display, response_display, grade_display, index_num])
    
    btn_good.click(fn=lambda i: save_grade(i, "Good"), inputs=index_num, outputs=[prompt_display, response_display, grade_display, index_num])
    btn_bad.click(fn=lambda i: save_grade(i, "Bad"), inputs=index_num, outputs=[prompt_display, response_display, grade_display, index_num])
    
    btn_next.click(fn=lambda i: update_ui(i + 1), inputs=index_num, outputs=[prompt_display, response_display, grade_display, index_num])
    btn_prev.click(fn=lambda i: update_ui(i - 1), inputs=index_num, outputs=[prompt_display, response_display, grade_display, index_num])

if __name__ == "__main__":
    demo.launch()