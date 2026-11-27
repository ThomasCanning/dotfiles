#!/bin/zsh
# Commits and pushes any changes in ~/dotfiles. Run every 30 minutes by the
# LaunchAgent in ~/Library/LaunchAgents/com.tcanning.dotfiles-sync.plist.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
cd "$HOME/dotfiles" || exit 1

echo "--- $(date '+%Y-%m-%d %H:%M:%S')"
git add -A
if ! git diff --cached --quiet; then
  git commit -q -m "Auto-sync $(date '+%Y-%m-%d %H:%M')" && echo "committed"
fi

# a failed push (e.g. offline) is retried on the next run, since the commit stays local
if [ -n "$(git log origin/main..main --oneline 2>/dev/null)" ]; then
  git pull -q --rebase origin main && git push -q origin main && echo "pushed"
fi
