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

On startup, the VM mounts the host's `~/.jails` directory onto
`/home/vagrant`. The setup ensures `~/.jails` and its `.ssh` directory
exist, copies the host's `~/.ssh/id_rsa.pub` into
`~/.jails/.ssh/authorized_keys`, and allows SSH agent-backed keys by
setting `config.ssh.keys_only = false`.

Additional host directories can be mounted into the guest by setting
indexed environment variables before `vagrant up` or `vagrant reload`,
for example `JAILS_MOUNT_1=/absolute/host/path:/absolute/guest/path`.
Indexes are read sequentially starting at `1`, both paths must be
absolute, and the host source must already exist as a directory.

Provisioning is split into named steps:

- `skel` syncs `/etc/skel/` into `/home/vagrant/`.
- `cache` prepares `/cache` and symlinks the vagrant user's `nvm`, npm,
  and Homebrew cache directories into it.
- `apt` installs Ruby, Bubblewrap, and kitty terminfo.
- `brew` installs Homebrew, configures `/etc/profile.d/brew.sh`, and
  installs Go, GitHub CLI (`gh`), and the `claude-code` cask.
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
Keep unrelated installs split across separate provisioning steps or
helper methods so they can be rerun independently with:

```bash
vagrant provision --provision-with <name>
```

When adding guest mounts, preserve the indexed `JAILS_MOUNT_n` pattern
instead of introducing one-off synced-folder wiring.
