import os
import json
from dotenv import load_dotenv
from azure.identity import DefaultAzureCredential
from azure.ai.projects import AIProjectClient

load_dotenv()

PROJECT_ENDPOINT = os.environ["PROJECT_ENDPOINT"]
MODEL_NAME = os.environ["MODEL_NAME"]

# Authenticate and create clients
project = AIProjectClient(
    endpoint=PROJECT_ENDPOINT,
    credential=DefaultAzureCredential(),
)
openai = project.get_openai_client()

SYSTEM_PROMPT = """You are an expert e-commerce copywriter. 
Given a product name and a list of attributes, generate a compelling product 
description (2-3 sentences) that highlights key benefits and appeals to buyers.
Return valid JSON with keys: "title", "description", "tags"."""


def generate_description(product_name: str, attributes: dict) -> dict:
    """Call GPT to generate a product description."""
    user_input = (
        f"Product: {product_name}\n"
        f"Attributes: {json.dumps(attributes)}"
    )

    response = openai.responses.create(
        model=MODEL_NAME,
        instructions=SYSTEM_PROMPT,
        input=user_input,
    )

    return json.loads(response.output_text)


if __name__ == "__main__":
    # Example product
    result = generate_description(
        product_name="TrailBlazer Pro Hiking Boots",
        attributes={
            "material": "Full-grain leather + Gore-Tex lining",
            "sole": "Vibram Megagrip",
            "weight": "620g per boot",
            "waterproof": True,
            "colors": ["Earth Brown", "Charcoal"],
        },
    )

    print(json.dumps(result, indent=2))
