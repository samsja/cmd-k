#!/bin/bash

set -e

echo "Installing cmd-k from GitHub..."

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "Error: uv is not installed. Please install it first:"
    echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

# Install cmd-k globally using uv tool
echo "Installing cmd-k as a global tool..."
uv tool install git+https://github.com/samsja/cmd-k

echo ""
echo "✓ cmd-k installed successfully!"
echo ""

# Create config file if it doesn't exist
CONFIG_DIR="$HOME/.config"
CONFIG_FILE="$CONFIG_DIR/cmd-k.toml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Setting up configuration..."
    echo ""

    # Ask for provider
    echo "Which API provider do you want to use?"
    echo "1) OpenAI (default)"
    echo "2) vLLM"
    echo "3) OpenRouter"
    read -p "Choose [1-3] (default: 1): " provider_choice
    provider_choice=${provider_choice:-1}

    mkdir -p "$CONFIG_DIR"

    case $provider_choice in
        1)
            # OpenAI
            read -p "Enter your OpenAI API key: " api_key
            read -p "Enter model name (default: gpt-4o-mini): " model
            model=${model:-gpt-4o-mini}

            cat > "$CONFIG_FILE" << 'CONFIGEOF'
# cmd-k configuration - OpenAI
api_key = "API_KEY_PLACEHOLDER"
model = "MODEL_PLACEHOLDER"
CONFIGEOF
            sed -i "s|API_KEY_PLACEHOLDER|$api_key|g" "$CONFIG_FILE"
            sed -i "s|MODEL_PLACEHOLDER|$model|g" "$CONFIG_FILE"
            ;;
        2)
            # vLLM
            read -p "Enter vLLM base URL (e.g., http://localhost:8000/v1): " base_url
            read -p "Enter model name: " model

            cat > "$CONFIG_FILE" << 'CONFIGEOF'
# cmd-k configuration - vLLM
api_key = "EMPTY"
base_url = "BASE_URL_PLACEHOLDER"
model = "MODEL_PLACEHOLDER"
CONFIGEOF
            sed -i "s|BASE_URL_PLACEHOLDER|$base_url|g" "$CONFIG_FILE"
            sed -i "s|MODEL_PLACEHOLDER|$model|g" "$CONFIG_FILE"
            ;;
        3)
            # OpenRouter
            read -p "Enter your OpenRouter API key: " api_key
            read -p "Enter model name (e.g., openai/gpt-4o-mini): " model

            cat > "$CONFIG_FILE" << 'CONFIGEOF'
# cmd-k configuration - OpenRouter
api_key = "API_KEY_PLACEHOLDER"
base_url = "https://openrouter.ai/api/v1"
model = "MODEL_PLACEHOLDER"
CONFIGEOF
            sed -i "s|API_KEY_PLACEHOLDER|$api_key|g" "$CONFIG_FILE"
            sed -i "s|MODEL_PLACEHOLDER|$model|g" "$CONFIG_FILE"
            ;;
        *)
            echo "Invalid choice. Please run the installer again."
            exit 1
            ;;
    esac

    echo ""
    echo "✓ Config file created at $CONFIG_FILE"
    echo ""
else
    echo "Config file already exists at $CONFIG_FILE"
    echo ""
fi

# Detect the shell
DETECTED_SHELL=$(basename "$SHELL")

# Define shell integration code
BASH_INTEGRATION='# cmd-k shell integration for bash
ck() {
    local cmd=$(cmd-k "$@")
    read -e -p "$ " -i "$cmd" final_cmd
    if [[ -n "$final_cmd" ]]; then
        eval "$final_cmd"
    fi
}'

ZSH_INTEGRATION='# cmd-k shell integration for zsh
ck() {
    local cmd=$(cmd-k "$@")
    print -z "$cmd"
}'

if [ "$DETECTED_SHELL" = "zsh" ]; then
    RC_FILE="~/.zshrc"
    SHELL_CODE="$ZSH_INTEGRATION"
elif [ "$DETECTED_SHELL" = "bash" ]; then
    RC_FILE="~/.bashrc"
    SHELL_CODE="$BASH_INTEGRATION"
else
    echo "Warning: Could not detect shell type. Showing both examples."
    echo ""
    echo "=== For Bash (~/.bashrc) ==="
    echo "$BASH_INTEGRATION"
    echo ""
    echo "=== For Zsh (~/.zshrc) ==="
    echo "$ZSH_INTEGRATION"
    exit 0
fi

echo "Add the following to your $RC_FILE:"
echo ""
echo "$SHELL_CODE"
echo ""
echo "To add it automatically, run:"
echo "  echo '$SHELL_CODE' >> $RC_FILE"
echo ""
echo "Then reload your shell:"
echo "  source $RC_FILE"
