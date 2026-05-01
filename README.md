# jails

Isolated environments for AI coding agents.

**jails** provides a ready-to-use Vagrant development environment for
running AI coding tools, such as Claude Code, OpenCode, and Codex, away
from the host system. The goal is to give agents the filesystem,
network, and command access they need while limiting the blast radius on
the host.

## Rationale

AI coding agents are useful because they can inspect projects, edit
files, install dependencies, and run commands. Giving that level of
access directly to a host machine is risky. This repository collects a
VM-based development environment that makes those capabilities available
inside a more controlled environment.

## Structure

The repository is intentionally small:

- `Vagrantfile` defines the VM and named provisioning steps.
- `.ai/AGENTS.md` is the shared source for agent instructions.
- `AGENTS.md` and `CLAUDE.md` are symlinks to `.ai/AGENTS.md`.
- `.gitignore` excludes generated Vagrant state and logs.

## Vagrant

The root `Vagrantfile` defines an Ubuntu VM using `bento/ubuntu-25.04`
with 4 GB of memory. It uses Vagrant's default project share, so this
repository is available in the guest at `/vagrant`.

Provisioning is split into named steps:

- `apt` installs Ruby, Bubblewrap, and kitty terminfo.
- `brew` installs Homebrew, configures `/etc/profile.d/brew.sh`, and
  installs Go and GitHub CLI (`gh`).
- `claude` installs Claude Code from Anthropic's install script.
- `node` installs `nvm`, Node.js 24, and the global npm packages
  `opencode-ai` and `@openai/codex`.

Generated VM state and logs are intentionally ignored via `.vagrant/`
and `*.log`.

Start the VM:

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

## Agent Instructions

Shared agent guidance lives in `.ai/AGENTS.md`. The repository root
contains `AGENTS.md` and `CLAUDE.md` symlinks that both point to that
file, so Codex-style and Claude-style agents read the same project
instructions.

## Adding Tools or Stacks

Add tools or stacks as focused named provisioners in `Vagrantfile`.
Keep unrelated installs split across separate provisioning steps so they
can be rerun independently with:

```bash
vagrant provision --provision-with <name>
```

## Status

Early stages of the project. The current path is Vagrant-based and
focused on VM experimentation with Node-based coding agents.
