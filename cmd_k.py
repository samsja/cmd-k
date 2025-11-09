import os
import sys
from pathlib import Path

import toml
from openai import OpenAI


def load_config() -> dict:
    """Load configuration from ~/.config/cmd-k.toml or use defaults."""
    config_path = Path.home() / ".config" / "cmd-k.toml"

    # Default configuration
    config = {
        "api_key": os.environ.get("OPENAI_API_KEY", ""),
        "base_url": None,
        "model": "gpt-5-nano-2025-08-07",
    }

    # Load from config file if it exists
    if config_path.exists():
        try:
            file_config = toml.load(config_path)
            # Override defaults with config file values
            if "api_key" in file_config:
                config["api_key"] = file_config["api_key"]
            if "base_url" in file_config:
                config["base_url"] = file_config["base_url"]
            if "model" in file_config:
                config["model"] = file_config["model"]
        except Exception as e:
            print(f"Warning: Failed to load config file: {e}", file=sys.stderr)

    # Environment variables override config file
    if os.environ.get("OPENAI_API_KEY"):
        config["api_key"] = os.environ.get("OPENAI_API_KEY")
    if os.environ.get("OPENAI_BASE_URL"):
        config["base_url"] = os.environ.get("OPENAI_BASE_URL")
    if os.environ.get("OPENAI_MODEL"):
        config["model"] = os.environ.get("OPENAI_MODEL")

    return config


def get_command_from_llm(prompt: str) -> str:
    """Get a shell command from OpenAI-compatible API based on the prompt."""
    config = load_config()

    # Create client with optional base_url
    client = OpenAI(
        api_key=config["api_key"],
        base_url=config["base_url"],
    )

    system_prompt = """You are a shell command generator. Convert natural language descriptions into shell commands.
Only return the command itself, nothing else. No explanations, no markdown, no code blocks.
Examples:
- "list all files" -> ls -la
- "find python files" -> find . -name "*.py"
- "show git status" -> git status"""

    response = client.chat.completions.create(
        model=config["model"],
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": prompt},
        ],
        temperature=0,
        max_tokens=100,
    )

    command = response.choices[0].message.content.strip()
    return command


def main():
    # Read the prompt from arguments
    if len(sys.argv) > 1:
        prompt = " ".join(sys.argv[1:])
    else:
        prompt = ""

    if not prompt:
        print("Error: Please provide a prompt", file=sys.stderr)
        sys.exit(1)

    # Get command from LLM
    try:
        command = get_command_from_llm(prompt)
    except Exception as e:
        print(f"Error calling OpenAI: {e}", file=sys.stderr)
        sys.exit(1)

    # Output only the command
    print(command)


if __name__ == "__main__":
    main()
