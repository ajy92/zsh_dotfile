#!/usr/bin/env bash
set -euo pipefail

# ===========================================
# Agent Workspace — tmux 멀티 에이전트 레이아웃
# ===========================================
#
# 레이아웃:
# ┌──────────────────┬──────────────┐
# │                  │  Test/Build  │
# │   Main Agent     │  (우상단)     │
# │   (좌측 60%)     ├──────────────┤
# │                  │  Git/Logs    │
# │                  │  (우하단)     │
# └──────────────────┴──────────────┘
#
# 사용법:
#   ./agent-workspace.sh [세션명] [프로젝트경로]
#
# 예시:
#   ./agent-workspace.sh                     # 기본값 사용
#   ./agent-workspace.sh myproject           # 세션명 지정
#   ./agent-workspace.sh myproject ~/code    # 세션명 + 경로 지정

SESSION="${1:-agent}"
PROJECT_DIR="${2:-$(pwd)}"

# tmux 설치 확인
if ! command -v tmux &>/dev/null; then
  echo "tmux가 설치되지 않았습니다."
  echo "설치: brew install tmux (macOS) 또는 sudo apt install tmux (Linux)"
  exit 1
fi

# 프로젝트 경로 확인
if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "디렉토리가 존재하지 않습니다: $PROJECT_DIR"
  exit 1
fi

# 이미 같은 이름의 세션이 있으면 attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "기존 세션 '$SESSION'에 연결합니다."
  exec tmux attach-session -t "$SESSION"
fi

echo "=== Agent Workspace ==="
echo "세션: $SESSION"
echo "경로: $PROJECT_DIR"
echo ""

# 세션 생성 (메인 창 — 좌측, AI 에이전트용)
tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" -x "$(tput cols)" -y "$(tput lines)"
tmux rename-window -t "$SESSION:1" "workspace"

# 우측 분할 (40%)
tmux split-window -h -t "$SESSION:1" -c "$PROJECT_DIR" -l "40%"

# 우측을 상하로 분할 (50:50)
tmux split-window -v -t "$SESSION:1.2" -c "$PROJECT_DIR" -l "50%"

# --- 각 패인에 안내 메시지 표시 ---

# 패인 1 (좌측): 메인 에이전트
tmux send-keys -t "$SESSION:1.1" "echo '🤖 [Main Agent] AI 코딩 에이전트 실행 대기'" Enter
tmux send-keys -t "$SESSION:1.1" "echo '  aider, claude, cursor 등을 여기서 실행하세요'" Enter
tmux send-keys -t "$SESSION:1.1" "echo ''" Enter

# 패인 2 (우상단): 테스트/빌드 감시
tmux send-keys -t "$SESSION:1.2" "echo '🧪 [Test/Build] 실시간 테스트 또는 빌드 감시'" Enter
tmux send-keys -t "$SESSION:1.2" "echo '  npm test -- --watch'" Enter
tmux send-keys -t "$SESSION:1.2" "echo '  npm run dev'" Enter
tmux send-keys -t "$SESSION:1.2" "echo ''" Enter

# 패인 3 (우하단): Git/로그
tmux send-keys -t "$SESSION:1.3" "echo '📋 [Git/Logs] 시스템 로그 또는 Git 상태'" Enter
tmux send-keys -t "$SESSION:1.3" "echo '  git log --oneline --graph -20'" Enter
tmux send-keys -t "$SESSION:1.3" "echo '  tail -f logs/app.log'" Enter
tmux send-keys -t "$SESSION:1.3" "echo ''" Enter
tmux send-keys -t "$SESSION:1.3" "git status 2>/dev/null || true" Enter

# 메인 패인(좌측)에 포커스
tmux select-pane -t "$SESSION:1.1"

echo "워크스페이스가 준비되었습니다!"
echo ""

# attach
exec tmux attach-session -t "$SESSION"
