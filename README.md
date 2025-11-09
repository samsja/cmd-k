# cmd-k

**Transform natural language into shell commands with AI**

cmd-k is a command-line tool that converts your natural language descriptions into executable shell commands. Powered by OpenAI-compatible APIs (OpenAI, vLLM, OpenRouter), it helps you quickly find the right command without memorizing syntax.

Instead of searching documentation, just describe what you want to do:
- "list all files" → `ls -la`
- "find python files" → `find . -name "*.py"`
- "remove all node_modules folders" → `find . -name "node_modules" -type d -exec rm -rf {} +`

The command appears pre-filled in your terminal - review it, edit if needed, then press Enter to execute.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/samsja/cmd-k/main/install.sh | bash
```

Or manually:

```bash
# Install as a global tool
uv tool install git+https://github.com/samsja/cmd-k

# Add shell integration (see shells/zsh.sh or shells/bash.sh)
```

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

## Usage

After installing the shell integration, use `ck` followed by your natural language prompt:

```bash
# List files
ck list all files
# → ls -la

# Find files
ck find all python files
# → find . -name "*.py"

# Git operations
ck show git status
# → git status

ck commit all changes with message "update"
# → git add . && git commit -m "update"

# File operations
ck count lines in all python files
# → find . -name "*.py" -exec wc -l {} +

# Process management
ck show all running node processes
# → ps aux | grep node

# System info
ck check disk usage
# → df -h
```

The generated command appears in your terminal input - review it, modify if needed, then press Enter to execute.

## Development

Install [uv](https://github.com/astral-sh/uv) and sync the environment:

```bash
uv sync
```
