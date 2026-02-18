#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS=(zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

# --- 함수 정의 ---

install_zsh() {
  if command -v zsh &>/dev/null; then
    echo "zsh 이미 설치됨: $(zsh --version)"
    return
  fi
  echo "zsh 설치 중..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update && sudo apt-get install -y zsh || sudo yum install -y zsh
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS에는 zsh가 기본 설치되어 있습니다."
  fi
}

install_omz() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "Oh My Zsh 이미 설치됨"
    return
  fi
  echo "Oh My Zsh 설치 중..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

install_plugins() {
  for plugin in "${PLUGINS[@]}"; do
    if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
      echo "$plugin 설치 중..."
      git clone "https://github.com/zsh-users/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
    else
      echo "$plugin 이미 설치됨"
    fi
  done
}

link_zshrc() {
  if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    backup="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    echo "기존 .zshrc 백업 → $backup"
    mv "$HOME/.zshrc" "$backup"
  fi
  ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  echo ".zshrc 심링크 완료"
}

create_local() {
  if [[ ! -f "$HOME/.zshrc.local" ]]; then
    cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
    echo "~/.zshrc.local 생성됨 — 머신별 설정을 편집하세요."
  else
    echo "~/.zshrc.local 이미 존재함 (건너뜀)"
  fi
}

# --- install: 최초 설치 ---

do_install() {
  echo "=== Dotfiles 설치 ==="
  echo ""
  install_zsh
  install_omz
  install_plugins
  link_zshrc
  create_local
  echo ""
  echo "=== 설치 완료! ==="
  echo "'exec zsh'로 적용하세요."
}

# --- update: dotfiles + 플러그인 업데이트 ---

do_update() {
  echo "=== Dotfiles 업데이트 ==="
  echo ""

  # dotfiles 저장소 pull
  echo "[1/4] dotfiles 저장소 업데이트 중..."
  git -C "$DOTFILES_DIR" pull --rebase

  # Oh My Zsh 업데이트
  echo ""
  echo "[2/4] Oh My Zsh 업데이트 중..."
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    git -C "$HOME/.oh-my-zsh" pull --rebase
  else
    echo "Oh My Zsh 미설치 — 'bootstrap.sh install'로 먼저 설치하세요."
  fi

  # 플러그인 업데이트
  echo ""
  echo "[3/4] 플러그인 업데이트 중..."
  for plugin in "${PLUGINS[@]}"; do
    if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
      echo "  $plugin 업데이트 중..."
      git -C "$ZSH_CUSTOM/plugins/$plugin" pull --rebase
    else
      echo "  $plugin 미설치 — 설치 중..."
      git clone "https://github.com/zsh-users/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
    fi
  done

  # 심링크 확인
  echo ""
  echo "[4/4] 심링크 확인 중..."
  link_zshrc

  echo ""
  echo "=== 업데이트 완료! ==="
  echo "'exec zsh'로 적용하세요."
}

# --- status: 현재 상태 확인 ---

do_status() {
  echo "=== Dotfiles 상태 ==="
  echo ""

  echo "dotfiles: $DOTFILES_DIR"
  echo "  branch: $(git -C "$DOTFILES_DIR" branch --show-current 2>/dev/null || echo 'N/A')"
  echo "  commit: $(git -C "$DOTFILES_DIR" log --oneline -1 2>/dev/null || echo 'N/A')"
  echo ""

  echo "Oh My Zsh: $([ -d "$HOME/.oh-my-zsh" ] && echo '설치됨' || echo '미설치')"
  echo ""

  echo "플러그인:"
  for plugin in "${PLUGINS[@]}"; do
    if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
      echo "  $plugin: 설치됨"
    else
      echo "  $plugin: 미설치"
    fi
  done
  echo ""

  echo ".zshrc 심링크:"
  if [[ -L "$HOME/.zshrc" ]]; then
    echo "  $(ls -l "$HOME/.zshrc" | awk -F' -> ' '{print $2}')"
  else
    echo "  심링크 아님 (bootstrap.sh install 실행 필요)"
  fi
}

# --- 사용법 ---

show_usage() {
  echo "사용법: ./bootstrap.sh [명령]"
  echo ""
  echo "명령:"
  echo "  install   최초 설치 (기본값)"
  echo "  update    dotfiles, Oh My Zsh, 플러그인 업데이트"
  echo "  status    현재 설치 상태 확인"
  echo "  help      이 도움말 표시"
}

# --- 메인 ---

case "${1:-install}" in
  install) do_install ;;
  update)  do_update ;;
  status)  do_status ;;
  help|-h|--help) show_usage ;;
  *)
    echo "알 수 없는 명령: $1"
    show_usage
    exit 1
    ;;
esac
