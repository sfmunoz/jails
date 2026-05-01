# Agent Instructions

## Project

This repository contains isolated environments for AI coding agents. The main
surface is the Vagrant-based development environment and its provisioning
steps.

## Repository Layout

- `Vagrantfile` defines the VM-based development environment and its named
  provisioning steps.
- `README.md` describes the project goals, environment layout, and usage notes.
- `.ai/AGENTS.md` is the shared source for agent instructions.
- `AGENTS.md` and `CLAUDE.md` are symlinks to `.ai/AGENTS.md`.

## Working Guidelines

- Keep changes scoped to the requested jail, tool, stack, or provisioning step.
- Treat VM box names, provider settings, users, installed tool versions, and
  provisioning step names as part of the public behavior unless the task
  explicitly asks to change them.
- The repository uses Vagrant's default project share. Do not reintroduce a
  custom `/home/vagrant/src/jails` synced folder unless intentionally changing
  guest filesystem semantics.
- Keep Vagrant provisioning organized by named steps (`apt`, `brew`, `claude`,
  `node`) instead of folding unrelated installs into one shell block.
- Avoid committing generated logs or local runtime state; `.vagrant/` and
  `*.log` are ignored intentionally.
- Do not rewrite unrelated Vagrant configuration while adding a tool or stack.

## Common Commands

Start the Vagrant VM:

```bash
vagrant up
```

Run a specific provisioning step:

```bash
vagrant provision --provision-with node
```

Connect to the VM:

```bash
vagrant ssh
```

## Verification

- For Vagrant changes, validate with Vagrant only when the local environment has
  the required provider available.
- For provisioning changes, prefer running the affected named provisioner with
  `vagrant provision --provision-with <name>` when practical.
- When changing Vagrant provisioning, keep the expected toolchain in mind:
  `apt` installs Ruby, Bubblewrap, and kitty terminfo; Homebrew installs Go and
  GitHub CLI; Claude Code is installed from Anthropic's install script; nvm
  installs Node.js 24 plus global `opencode-ai` and `@openai/codex`.
