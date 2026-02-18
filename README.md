# Dotfiles

macOS/Linux 공통 zsh 설정을 관리하는 dotfiles 저장소.

## 구조

```
dotfiles/
├── bootstrap.sh              # 원클릭 설치 스크립트
└── zsh/
    ├── .zshrc                # 공통 설정 (모든 OS)
    └── .zshrc.local.example  # 머신별 설정 템플릿
```

## 설치

```bash
git clone https://github.com/<username>/dotfiles.git ~/github/dotfiles
cd ~/github/dotfiles
./bootstrap.sh
```

`bootstrap.sh`가 하는 일:
1. zsh 설치 확인 (Linux면 자동 설치)
2. Oh My Zsh 설치
3. 외부 플러그인 설치 (autosuggestions, syntax-highlighting, completions)
4. 기존 `~/.zshrc` 백업 후 심링크 생성
5. `~/.zshrc.local`이 없으면 example에서 복사

## 머신별 설정

설치 후 `~/.zshrc.local`을 편집하여 머신별 설정을 추가하세요.
이 파일은 Git에 추적되지 않습니다.

```bash
vi ~/.zshrc.local
```

macOS 예시: Homebrew PATH, JAVA_HOME, Android SDK 등
Linux 예시: linuxbrew, snap 경로 등

## 동기화

```bash
# 변경한 머신에서
cd ~/github/dotfiles
git add -A && git commit -m "chore: update zshrc" && git push

# 다른 머신에서
cd ~/github/dotfiles && git pull
# .zshrc는 심링크이므로 자동 반영
```
