#!/usr/bin/env bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
CWD=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Gruvbox Dark palette (approximate ANSI true color)
COLOR_ORANGE='\033[38;2;214;93;14m'
COLOR_YELLOW='\033[38;2;215;153;33m'
COLOR_AQUA='\033[38;2;104;157;106m'
COLOR_BLUE='\033[38;2;69;133;136m'
COLOR_PURPLE='\033[38;2;177;98;134m'
COLOR_BG1='\033[38;2;60;56;54m'
COLOR_FG0='\033[38;2;251;241;199m'
COLOR_GREEN='\033[38;2;152;151;26m'
COLOR_RED='\033[38;2;204;36;29m'
RESET='\033[0m'
BOLD='\033[1m'

# Username and hostname (mirrors Starship username/hostname segment)
USER_HOST="${COLOR_ORANGE}${BOLD}$(whoami)${RESET}${COLOR_ORANGE}@$(hostname -s)${RESET}"

# Directory: truncate to last 3 parts, replace HOME with ~
HOME_ESC=$(printf '%s' "$HOME" | sed 's/[]\/$*.^[]/\\&/g')
SHORT_DIR=$(echo "$CWD" | sed "s|^$HOME_ESC|~|")
# Keep up to last 3 path components
SHORT_DIR=$(echo "$SHORT_DIR" | awk -F/ '{
  n = NF
  if (n <= 3) { print $0 }
  else {
    out = ""
    for (i = n-2; i <= n; i++) out = (out == "" ? "" : out "/") $i
    print ".../" out
  }
}')

# Git branch and status (mirrors Starship git_branch/git_status)
BRANCH=""
if git -c gc.auto=0 rev-parse --git-dir >/dev/null 2>&1; then
  GIT_BRANCH=$(git -c gc.auto=0 branch --show-current 2>/dev/null)
  GIT_STATUS=""
  # Check for common status indicators
  STATUS_FLAGS=$(git -c gc.auto=0 status --porcelain 2>/dev/null)
  [ -n "$STATUS_FLAGS" ] && GIT_STATUS="*"
  AHEAD=$(git -c gc.auto=0 rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
  BEHIND=$(git -c gc.auto=0 rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
  [ "$AHEAD" -gt 0 ] 2>/dev/null && GIT_STATUS="${GIT_STATUS}+"
  [ "$BEHIND" -gt 0 ] 2>/dev/null && GIT_STATUS="${GIT_STATUS}-"
  BRANCH=" ${COLOR_AQUA} ${GIT_BRANCH}${GIT_STATUS}${RESET}"
fi

# Time (mirrors Starship time segment)
TIME="${COLOR_BG1}$(date +%H:%M)${RESET}"

# Context window bar
if [ "$PCT" -ge 90 ]; then
  BAR_COLOR="$COLOR_RED"
elif [ "$PCT" -ge 70 ]; then
  BAR_COLOR="$COLOR_YELLOW"
else
  BAR_COLOR="$COLOR_GREEN"
fi
FILLED=$((PCT / 10))
EMPTY=$((10 - FILLED))
BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=0; i<EMPTY; i++)); do BAR+="░"; done

# Line 1: user@host  dir  branch  time
printf "${USER_HOST}  ${COLOR_YELLOW}${SHORT_DIR}${RESET}${BRANCH}  ${TIME}\n"
# Line 2: model  context bar
printf "${COLOR_PURPLE}${MODEL}${RESET}  ${BAR_COLOR}${BAR}${RESET} ${PCT}%%\n"
