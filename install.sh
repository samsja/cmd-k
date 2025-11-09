#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Installing cmd-k${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo -e "${RED}✗ Error: uv is not installed${NC}"
    echo ""
    echo "Please install it first:"
    echo -e "  ${BOLD}curl -LsSf https://astral.sh/uv/install.sh | sh${NC}"
    exit 1
fi

# Install cmd-k globally using uv tool
echo -e "${BLUE}→${NC} Installing cmd-k as a global tool..."
uv tool install git+https://github.com/samsja/cmd-k

echo ""
echo -e "${GREEN}✓ cmd-k installed successfully!${NC}"
echo ""

# Create config file if it doesn't exist
CONFIG_DIR="$HOME/.config"
CONFIG_FILE="$CONFIG_DIR/cmd-k.toml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${BOLD}Configuration Setup${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Ask for provider
    echo "Which API provider do you want to use?"
    echo -e "  ${CYAN}${BOLD}1)${NC} OpenAI (default)"
    echo -e "  ${CYAN}${BOLD}2)${NC} vLLM"
    echo -e "  ${CYAN}${BOLD}3)${NC} OpenRouter"
    echo ""
    echo -ne "${MAGENTA}Choose [1-3] (default: 1): ${NC}"
    read provider_choice
    provider_choice=${provider_choice:-1}

    mkdir -p "$CONFIG_DIR"

    case $provider_choice in
        1)
            # OpenAI
            echo ""
            echo -ne "${MAGENTA}Enter your OpenAI API key: ${NC}"
            read api_key
            echo -ne "${MAGENTA}Enter model name (default: gpt-4o-mini): ${NC}"
            read model
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
            echo ""
            echo -ne "${MAGENTA}Enter vLLM base URL (e.g., http://localhost:8000/v1): ${NC}"
            read base_url
            echo -ne "${MAGENTA}Enter model name: ${NC}"
            read model

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
            echo ""
            echo -ne "${MAGENTA}Enter your OpenRouter API key: ${NC}"
            read api_key
            echo -ne "${MAGENTA}Enter model name (e.g., openai/gpt-4o-mini): ${NC}"
            read model

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
    echo -e "${GREEN}✓ Config file created at $CONFIG_FILE${NC}"
    echo ""
else
    echo -e "${YELLOW}⚠ Config file already exists at $CONFIG_FILE${NC}"
    echo ""
fi

# Shell integration instructions
echo -e "${BOLD}Shell Integration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Add the shell integration to your shell config:"
echo ""

echo -e "${BOLD}For Bash (~/.bashrc):${NC}"
echo -e "${BLUE}─────────────────────────────────────────────${NC}"
echo -e "${YELLOW}${BOLD}cat >> ~/.bashrc << 'EOF'
# cmd-k shell integration
ck() {
    local cmd=\$(cmd-k \"\$@\")
    read -e -p \"\$ \" -i \"\$cmd\" final_cmd
    if [[ -n \"\$final_cmd\" ]]; then
        eval \"\$final_cmd\"
    fi
}
EOF${NC}"
echo -e "${BLUE}─────────────────────────────────────────────${NC}"
echo ""

echo -e "${BOLD}For Zsh (~/.zshrc):${NC}"
echo -e "${BLUE}─────────────────────────────────────────────${NC}"
echo -e "${YELLOW}${BOLD}cat >> ~/.zshrc << 'EOF'
# cmd-k shell integration
ck() {
    local cmd=\$(cmd-k \"\$@\")
    print -z \"\$cmd\"
}
EOF${NC}"
echo -e "${BLUE}─────────────────────────────────────────────${NC}"
echo ""

echo -e "${GREEN}${BOLD}Then reload your shell:${NC}"
echo -e "  ${YELLOW}${BOLD}source ~/.bashrc${NC}  ${BLUE}# or${NC}  ${YELLOW}${BOLD}source ~/.zshrc${NC}"
echo ""
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete! Try: ${BOLD}ck list all files${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
