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

### 요구사항

- macOS 또는 Linux (Ubuntu/Debian, CentOS/RHEL)
- `git`, `curl` 설치 필요
- Linux의 경우 `sudo` 권한 (zsh 미설치 시)

### 빠른 설치 (원라인)

```bash
git clone https://github.com/ajy92/zsh_dotfile.git ~/github/dotfiles && cd ~/github/dotfiles && ./bootstrap.sh
```

### 단계별 설치

```bash
# 1. 저장소 클론
git clone https://github.com/ajy92/zsh_dotfile.git ~/github/dotfiles

# 2. 디렉토리 이동
cd ~/github/dotfiles

# 3. 설치 스크립트 실행
./bootstrap.sh

# 4. 셸 재시작
exec zsh
```

### `bootstrap.sh`가 하는 일

| 단계 | 설명 |
|------|------|
| 1 | zsh 설치 확인 (Linux면 자동 설치) |
| 2 | [Oh My Zsh](https://ohmyz.sh/) 설치 |
| 3 | 외부 플러그인 설치 (autosuggestions, syntax-highlighting, completions) |
| 4 | 기존 `~/.zshrc` 백업 후 심링크 생성 (`~/.zshrc` → `dotfiles/zsh/.zshrc`) |
| 5 | `~/.zshrc.local`이 없으면 example에서 복사 |

### 업데이트

dotfiles, Oh My Zsh, 플러그인을 한 번에 최신 버전으로 업데이트합니다.

```bash
cd ~/github/dotfiles
./bootstrap.sh update
```

### 상태 확인

현재 설치 상태(branch, 플러그인, 심링크)를 확인합니다.

```bash
./bootstrap.sh status
```

### 명령어 요약

| 명령 | 설명 |
|------|------|
| `./bootstrap.sh` | 최초 설치 (= `install`) |
| `./bootstrap.sh install` | 최초 설치 |
| `./bootstrap.sh update` | dotfiles + Oh My Zsh + 플러그인 업데이트 |
| `./bootstrap.sh status` | 현재 설치 상태 확인 |
| `./bootstrap.sh help` | 사용법 표시 |

### 포함된 플러그인

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — 히스토리 기반 자동 완성
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) — 명령어 구문 강조
- [zsh-completions](https://github.com/zsh-users/zsh-completions) — 추가 탭 완성

### 제거

```bash
# 심링크 제거 후 백업 복원
rm ~/.zshrc
mv ~/.zshrc.backup.* ~/.zshrc  # 백업이 있는 경우
```

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

# 다른 머신에서 (dotfiles + 플러그인 모두 업데이트)
cd ~/github/dotfiles
./bootstrap.sh update
# .zshrc는 심링크이므로 자동 반영
```
