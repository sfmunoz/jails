# Agent Instructions

## Project

This repository contains isolated environments for AI coding agents. The main
surfaces are Docker image definitions, Vagrant provisioning, and shell helpers
for building and running those environments.

## Repository Layout

- `base/docker/Dockerfile.base` defines the shared Debian-based image.
- `tools/claude-code/docker/plain/Dockerfile` defines the Claude Code image.
- `scripts/build.sh` builds and tags the local Docker images.
- `scripts/run.sh` runs the Claude Code Docker jail.
- `vagrant/Vagrantfile` defines the VM-based development environment and its
  named provisioning steps.

## Working Guidelines

- Keep changes scoped to the requested jail, tool, stack, or helper script.
- Preserve the existing shell style in `scripts/`: Bash scripts with explicit
  error handling and simple functions.
- Treat image tags, mounted paths, users, UIDs/GIDs, and working directories as
  part of the public behavior unless the task explicitly asks to change them.
- Preserve Vagrant synced-folder ownership unless intentionally changing guest
  user semantics; `/home/vagrant/src/jails` is mounted as `vagrant:vagrant`.
- Keep Vagrant provisioning organized by named steps (`apt`, `brew`, `claude`,
  `node`) instead of folding unrelated installs into one shell block.
- Avoid committing generated VM logs or local runtime state from `vagrant/`;
  `vagrant/*.log` is ignored intentionally.
- Do not rewrite unrelated Docker or Vagrant configuration while adding a tool
  or stack.

## Common Commands

Build all Docker images:

```bash
./scripts/build.sh
```

Run Claude Code in the Docker jail from a project directory exactly two levels
under `$HOME`:

```bash
./path/to/jails/scripts/run.sh
```

Run the container as root for debugging:

```bash
JAILS_ROOT=1 ./scripts/run.sh
```

## Verification

- For Docker changes, run `./scripts/build.sh` when Docker is available.
- For run-script changes, test normal mode from a valid two-level project path
  and root mode with `JAILS_ROOT=1`.
- For Vagrant changes, validate with Vagrant only when the local environment has
  the required provider available.
- When changing Vagrant provisioning, keep the expected toolchain in mind:
  `apt` installs Ruby, Bubblewrap, and kitty terminfo; Homebrew installs Go and
  GitHub CLI; Claude Code is installed from Anthropic's install script; nvm
  installs Node.js 24 plus global `opencode-ai` and `@openai/codex`.
