#!/bin/bash
# Install SDD skills as global Claude Code commands + agent
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"
AGENTS_DIR="$HOME/.claude/agents"

SKILLS=(
  brainstorming
  writing-plans
  subagent-driven-development
  executing-plans
  requesting-code-review
  finishing-a-development-branch
  using-git-worktrees
)

echo "Installing SDD skills..."

# Create target directories
mkdir -p "$COMMANDS_DIR" "$AGENTS_DIR"

# Symlink each skill directory
for skill in "${SKILLS[@]}"; do
  target="$COMMANDS_DIR/$skill"
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    echo "WARNING: $target exists and is not a symlink. Skipping."
    continue
  fi
  ln -s "$SCRIPT_DIR/$skill" "$target"
  echo "  Linked: $skill"
done

# Symlink agent definition
agent_target="$AGENTS_DIR/code-reviewer.md"
if [ -L "$agent_target" ]; then
  rm "$agent_target"
elif [ -e "$agent_target" ]; then
  echo "WARNING: $agent_target exists and is not a symlink. Skipping."
fi
if [ ! -e "$agent_target" ]; then
  ln -s "$SCRIPT_DIR/agents/code-reviewer.md" "$agent_target"
  echo "  Linked: agents/code-reviewer.md"
fi

echo ""
echo "Done. Installed ${#SKILLS[@]} skills + 1 agent."
echo "  Skills: $COMMANDS_DIR/"
echo "  Agent:  $AGENTS_DIR/code-reviewer.md"
