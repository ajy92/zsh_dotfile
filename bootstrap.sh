#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Bootstrap ==="

# 1. zsh 설치 확인
if ! command -v zsh &>/dev/null; then
  echo "zsh 설치 중..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update && sudo apt-get install -y zsh || sudo yum install -y zsh
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS에는 zsh가 기본 설치되어 있습니다."
  fi
fi

# 2. Oh My Zsh 설치
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Oh My Zsh 설치 중..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. 외부 플러그인 설치
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
for plugin in "${plugins[@]}"; do
  if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
    echo "$plugin 설치 중..."
    git clone "https://github.com/zsh-users/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
  fi
done

# 4. .zshrc 심링크
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  backup="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
  echo "기존 .zshrc 백업 → $backup"
  mv "$HOME/.zshrc" "$backup"
fi
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
echo ".zshrc 심링크 완료"

# 5. .zshrc.local 생성 (없을 때만)
if [[ ! -f "$HOME/.zshrc.local" ]]; then
  cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
  echo "~/.zshrc.local 생성됨 — 머신별 설정을 편집하세요."
fi

echo ""
echo "=== 설치 완료! ==="
echo "'exec zsh'로 적용하세요."
