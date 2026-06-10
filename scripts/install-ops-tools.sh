#!/usr/bin/env sh
set -eu

if [ "$(id -u)" -eq 0 ]; then
  echo "Run this script as a non-root operator user with sudo access." >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y build-essential curl file git procps

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew update
brew install k9s
brew cleanup

if ! grep -q '/home/linuxbrew/.linuxbrew/bin/brew shellenv' "$HOME/.bashrc" 2>/dev/null; then
  printf '\neval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"\n' >> "$HOME/.bashrc"
fi

echo
echo "Operator tools installed."
echo 'Reload your shell or run: eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
echo "Verify with: brew --version && k9s version"
