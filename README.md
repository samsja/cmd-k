# cmd-k

A command-line tool that converts natural language prompts into shell commands using OpenAI-compatible APIs.

## Configuration

Create `~/.config/cmd-k.toml`:

```toml
api_key = "your-api-key-here"
model = "gpt-4o-mini"  # Default model
# base_url = "https://api.openai.com/v1"  # Optional: for vLLM, OpenRouter, etc.
```

### Configuration Priority

1. Environment variables (highest priority)
2. Config file `~/.config/cmd-k.toml`
3. Defaults (OpenAI with gpt-4o-mini)

### Examples

**OpenAI (default):**
```toml
api_key = "sk-..."
model = "gpt-4o-mini"
```

**vLLM:**
```toml
api_key = "EMPTY"
base_url = "http://localhost:8000/v1"
model = "your-model-name"
```

**OpenRouter:**
```toml
api_key = "sk-or-..."
base_url = "https://openrouter.ai/api/v1"
model = "openai/gpt-4o-mini"
```

## Shell Integration

Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
source /path/to/cmd_k/shell_setup.sh
```

Works with both bash and zsh.

## Usage

```bash
ck list all files
# Output: ls -la
# The command appears in your terminal - press Enter to execute
```

## Development

Install [uv](https://github.com/astral-sh/uv) and sync the environment:

```bash
uv sync
```
