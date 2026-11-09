#!/bin/zsh
set -e

echo "       __      __  _____ __         ";
echo "  ____/ /___  / /_/ __(_) /__  _____";
echo " / __  / __ \/ __/ /_/ / / _ \/ ___/";
echo "/ /_/ / /_/ / /_/ __/ / /  __(__  ) ";
echo "\__,_/\____/\__/_/ /_/_/\___/____/  ";
echo "                                    ";

echo "Preflight check:"
echo ""

# Apple Silicon on macOS 26 or newer only
if [[ $(uname -m) != 'arm64' ]]; then
    echo -e "\033[0;31m Error: Apple Silicon (arm64) is required \033[0m"
    exit 1
fi
if (( $(sw_vers -productVersion | cut -d. -f1) < 26 )); then
    echo -e "\033[0;31m Error: macOS 26 or newer is required \033[0m"
    exit 1
fi
BREW_PREFIX="/opt/homebrew"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "\033[0;33m Installing Homebrew... \033[0m"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ ! -f $HOME/.zprofile ]] || ! grep -q "brew shellenv" $HOME/.zprofile; then
        (echo; echo 'eval "$('${BREW_PREFIX}'/bin/brew shellenv)"') >> $HOME/.zprofile
    fi
    eval "$($BREW_PREFIX/bin/brew shellenv)"
else
    echo -e "\033[0;32m Homebrew installed \033[0m"
fi

# Install Python 3.14, the newest version supported by the Ansible package
PYTHON_VERSION="3.14"
if ! brew list python@${PYTHON_VERSION} &> /dev/null; then
    echo -e "\033[0;33m Installing Python ${PYTHON_VERSION}... \033[0m"
    brew install python@${PYTHON_VERSION}
else
    echo -e "\033[0;32m Python ${PYTHON_VERSION} installed \033[0m"
fi

# Install pipx for isolated Python application management
if ! brew list pipx &> /dev/null; then
    echo -e "\033[0;33m Installing pipx... \033[0m"
    brew install pipx
    pipx ensurepath
    
    # Ensure pipx is in PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
else
    echo -e "\033[0;32m pipx installed \033[0m"
fi

# Ensure pipx is available in current session
if ! command -v pipx &> /dev/null; then
    export PATH="$HOME/.local/bin:$PATH"
fi

ANSIBLE_VERSION="14.6.0"
if ! pipx list | grep -q "package ansible "; then
    echo -e "\033[0;33m Installing Ansible ${ANSIBLE_VERSION} with pipx... \033[0m"
    pipx install \
        --python "$BREW_PREFIX/opt/python@${PYTHON_VERSION}/bin/python${PYTHON_VERSION}" \
        --include-deps ansible==$ANSIBLE_VERSION
    pipx inject --include-apps ansible kubernetes-validate markdown ansible-lint
    pipx inject ansible docker kubernetes boto3 netaddr

else
    echo -e "\033[0;32m Ansible installed \033[0m"
fi

echo ""
echo -e "Initialize playbook:\n"

# Verify ansible is available
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "\033[0;31m Error: ansible-playbook not found in PATH \033[0m"
    echo "You may need to restart your shell or run: source ~/.zprofile"
fi

ansible-playbook launch.yml
