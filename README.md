# cmd-k

cmd-k converts written instruction into executable shell commands. It's a cursor command that works from the terminal.

examples:

```bash
# List files
ck list all files
# → ls -la

# System info
ck check disk usage
# → df -h
```

The command appears pre-filled in your terminal, you just have to press Enter to execute it.

## Installation

it supports bash and zsh for now.


```bash
curl -fsSL https://raw.githubusercontent.com/samsja/cmd-k/main/install.sh | bash
```


<details>
<summary><b>Extra configuration</b></summary>

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

</details>



## credits

* cursor command k
* claude code for auto managing the code. (As of now, november 2025, this is the type of software that AI can manage end to end. Can't wait for the next 6 months of progress)
