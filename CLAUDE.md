# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A collection of 7 Claude Code skills (slash commands) and 1 agent definition that implement **Subagent-Driven Development (SDD)** — a multi-agent workflow for turning ideas into shipped code. Skills are installed globally via symlinks to `~/.claude/commands/` and `~/.claude/agents/`.

## Installation

```bash
./install.sh
```

Symlinks each skill directory to `~/.claude/commands/<skill-name>` and the agent to `~/.claude/agents/code-reviewer.md`.

## Architecture

### Skill Chain

The skills form a pipeline with strict gates between phases:

```
/brainstorming → /writing-plans → /subagent-driven-development (or /executing-plans) → /finishing-a-development-branch
                                         ↑                                                        ↑
                                  /using-git-worktrees                                  /requesting-code-review
```

- **brainstorming**: Design gate. No code without an approved spec. Only exit is `/writing-plans`.
- **writing-plans**: Converts specs into bite-sized TDD plans with real code in every step. No placeholders ever.
- **subagent-driven-development**: Dispatches a fresh subagent per task with two-stage review (spec compliance then code quality).
- **executing-plans**: Simpler alternative — batch execution in a separate session with periodic review checkpoints.
- **requesting-code-review**: Dispatches code-reviewer subagent with crafted context (not session history).
- **finishing-a-development-branch**: Verifies tests, presents 4 options (merge/PR/keep/discard), cleans up worktree.
- **using-git-worktrees**: Creates isolated workspaces with safety verification (gitignore check before creation).

### File Structure Per Skill

Each skill is a directory containing:
- `SKILL.md` — Main skill definition with YAML frontmatter (`name`, `description`) and the full prompt
- Optional prompt templates (e.g., `implementer-prompt.md`, `spec-reviewer-prompt.md`) used by the skill when dispatching subagents

The `agents/` directory contains agent definitions (YAML frontmatter with `name`, `description`, `model`).

### Convention: Specs and Plans

- Specs: `docs/specs/YYYY-MM-DD-<topic>-design.md`
- Plans: `docs/plans/YYYY-MM-DD-<feature-name>.md`

### Docs and Presentation

- `docs/sdd-overview.md` — Marp-formatted slide deck (the canonical overview)
- `docs/build_pptx.py` — Python script that builds a PPTX version using python-pptx with a PowerPoint template
- `docs/diagrams/` — Mermaid source (`.mmd`) with pre-rendered `.svg` and `.png` outputs

## Key Design Principles

These are enforced across all skills and should be maintained in any changes:

1. **Design-first gate** — no code without an approved spec
2. **Two-stage review** — spec compliance (right thing?) then code quality (built well?)
3. **Red/green TDD** — unconditional, tests before implementation
4. **No placeholders** — every plan step has actual code, exact commands, expected output
5. **Fresh subagents per task** — prevents context pollution
6. **YAGNI** — remove unnecessary features ruthlessly
