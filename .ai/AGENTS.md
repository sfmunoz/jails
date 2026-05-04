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
- Keep Vagrant provisioning organized by named steps (`apt`, `brew`, `node`)
  and helper methods instead of folding unrelated installs into one shell
  block.
- Preserve the current home-jail behavior unless the task explicitly changes
  it: the host `~/.jails` directory is prepared with `0700` permissions, and
  only selected jail-owned home directories are mounted into `/home/vagrant`
  (`~/.jails/.config` to `/home/vagrant/.config` and `~/.jails/.codex` to
  `/home/vagrant/.codex`).
- Preserve the current optional extra-mount behavior unless the task explicitly
  changes it: additional synced folders are configured through sequential
  `JAILS_MOUNT_n` environment variables using `/absolute/host:/absolute/guest`
  values, and the host source must already exist as a directory.
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
  `apt` installs Ruby, Bubblewrap, and kitty terminfo; Homebrew installs Go,
  GitHub CLI, and the `claude-code` cask; nvm installs Node.js 24 plus global
  `opencode-ai` and `@openai/codex`.
- When changing guest mounts, keep the current assumptions in mind: Vagrant's
  default project share remains enabled, selected home directories come from
  `~/.jails`, and optional extra mounts are discovered in order from
  `JAILS_MOUNT_1` upward.
