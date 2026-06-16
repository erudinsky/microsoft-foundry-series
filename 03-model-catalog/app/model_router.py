"""Smart model routing — pick the right model for the task complexity."""

import os

from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv

load_dotenv()

# ── Configuration ────────────────────────────────────────────────
PROJECT_ENDPOINT = os.environ["PROJECT_ENDPOINT"]

MODELS = {
    "simple": "gpt-4.1-nano",
    "standard": "gpt-4.1-mini",
    "complex": "gpt-5-mini",
}

client = AIProjectClient(
    endpoint=PROJECT_ENDPOINT,
    credential=DefaultAzureCredential(),
)


# ── Helpers ──────────────────────────────────────────────────────
def classify_complexity(task: str) -> str:
    """Ask the cheapest model to classify a task as simple / standard / complex."""
    response = client.inference.get_chat_completions_client().complete(
        model=MODELS["simple"],
        messages=[
            {
                "role": "system",
                "content": (
                    "Classify the following task as exactly one word: "
                    "simple, standard, or complex. Reply with that single word only."
                ),
            },
            {"role": "user", "content": task},
        ],
    )
    label = response.choices[0].message.content.strip().lower()
    if label not in MODELS:
        label = "standard"
    return label


def execute_task(task: str, system_prompt: str) -> str:
    """Classify the task, route to the right model, and return the response."""
    complexity = classify_complexity(task)
    model = MODELS[complexity]
    print(f"  → Complexity: {complexity}  |  Model: {model}")

    response = client.inference.get_chat_completions_client().complete(
        model=model,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": task},
        ],
    )
    return response.choices[0].message.content


# ── Demo ─────────────────────────────────────────────────────────
if __name__ == "__main__":
    tasks = [
        {
            "task": "Classify this product: 'Red Nike Air Max 90 sneakers, size 42'",
            "system_prompt": "You are a product classifier. Return the category.",
        },
        {
            "task": "Write a compelling product description for a premium wireless noise-cancelling headphone targeting young professionals.",
            "system_prompt": "You are a marketing copywriter. Write engaging product descriptions.",
        },
        {
            "task": "Develop a dynamic pricing strategy for an e-commerce platform that considers competitor pricing, inventory levels, demand elasticity, and seasonal trends.",
            "system_prompt": "You are a pricing strategist. Provide detailed, actionable strategies.",
        },
    ]

    for i, t in enumerate(tasks, 1):
        print(f"\n{'='*60}")
        print(f"Task {i}: {t['task'][:80]}...")
        result = execute_task(t["task"], t["system_prompt"])
        print(f"\nResult:\n{result}\n")
