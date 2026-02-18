# ===========================================
# Dotfiles — Common .zshrc (all OS)
# ===========================================

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  git
  docker
  docker-compose
  npm
  kubectl
  history
  aliases
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# --- Common aliases ---
alias python=python3

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ls (색상 + 정렬)
alias ll="ls -alFh"
alias la="ls -A"
alias lt="ls -alFht"   # 최근 수정순

# Git
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline --graph --decorate -20"
alias gla="git log --oneline --graph --decorate --all -20"
alias gp="git pull"
alias gpush="git push"
alias gc="git commit"
alias gca="git commit --amend"
alias gb="git branch"
alias gco="git checkout"
alias gsw="git switch"
alias gst="git stash"
alias gstp="git stash pop"

# Docker
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"

# 파일 검색 & 내용 검색
alias ff="find . -type f -name"
alias fg="grep -rn --color=auto"

# 네트워크
alias myip="curl -s ifconfig.me"
alias ports="lsof -i -P -n | grep LISTEN"

# 디스크 사용량
alias duh="du -h --max-depth=1 2>/dev/null | sort -hr"
alias dfh="df -h"

# 기타
alias cls="clear"
alias reload="exec zsh"
alias path='echo $PATH | tr ":" "\n"'
alias now="date '+%Y-%m-%d %H:%M:%S'"

# --- Machine-specific settings ---
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
