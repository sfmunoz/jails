# jails

Isolated environments for AI coding agents.

**jails** provides ready-to-use configurations for running AI coding
tools, such as Claude Code, OpenCode, and Codex, inside confined
environments. The goal is to give agents the filesystem, network, and
command access they need while limiting the blast radius on the host.

## Rationale

AI coding agents are useful because they can inspect projects, edit
files, install dependencies, and run commands. Giving that level of
access directly to a host machine is risky. This repository collects
Docker and Vagrant configurations that make those capabilities available
inside a more controlled environment.

## Structure

Configurations are organized across three dimensions:

- **Runtime** — how the jail is created (Docker, Vagrant, ...)
- **Tool** — the AI coding agent running inside (Claude Code, OpenCode, ...)
- **Stack** — the language/ecosystem available (Go, Node, Python, ...)

```
jails/
├── base/          # hardened base images, shared across tools and stacks
├── tools/         # per-tool configurations, layered on top of base
├── scripts/       # build and run helpers
└── vagrant/       # VM-based jail configuration
```

## Docker Images

The Docker setup is currently organized as a small image stack:

1. `base/docker/Dockerfile.base`
   - Starts from `debian:trixie-20260223-slim`.
   - Installs common tooling: `git`, `gh`, `jq`, `curl`, `sudo`, `less`,
     `procps`, `iputils-ping`, and CA certificates.
   - Creates a non-root `jails` user with UID/GID `1002`.

2. `tools/claude-code/docker/plain/Dockerfile`
   - Starts from `ghcr.io/sfmunoz/jails-base:latest`.
   - Prepares `/home/jails_local` for persistent local tool installs.
   - Installs Claude Code as the `jails` user.
   - Uses `/workspace` as the working directory.

## Building

Build all Docker images:

```bash
./scripts/build.sh
```

The build script creates:

- `ghcr.io/sfmunoz/jails-base`
- `ghcr.io/sfmunoz/jails-claude-code-plain`

Each image is tagged with a timestamp and with `latest`. Older local
timestamp tags are removed after each build.

## Running Claude Code

Run Claude Code inside the Docker jail:

```bash
./scripts/run.sh [optional-command]
```

The script must be run from exactly two directory levels under `$HOME`,
for example:

```bash
cd "$HOME/src/my-project"
./path/to/jails/scripts/run.sh
```

In normal mode, the container mounts:

- `~/.jails` as `/home/jails`
- the current directory as `/workspace`

The script also keeps `/home/jails/.local` as a symlink to
`../jails_local`, allowing Claude Code's local installation directory to
persist separately from the mounted home directory.

For debugging, run the container as root:

```bash
JAILS_ROOT=1 ./scripts/run.sh
```

Root mode does not mount the host project or `~/.jails`.

## Vagrant

The `vagrant/Vagrantfile` defines an Ubuntu VM using
`bento/ubuntu-25.04` with 4 GB of memory. It syncs this repository into
`/home/vagrant/src/jails` and provisions the VM with:

- GitHub CLI (`gh`)
- `nvm`
- Node.js 24
- `opencode-ai`
- `@openai/codex`

## Adding Tools or Stacks

To add another tool or stack, follow the existing Claude Code Docker
layout:

```text
tools/<tool-name>/docker/<variant>/Dockerfile
```

Tool images should start from:

```Dockerfile
FROM ghcr.io/sfmunoz/jails-base:latest
```

Then add the new image build step to `scripts/build.sh`.

## Status

Early stages of the project. The Docker path currently has the clearest
build/run flow; the Vagrant path is available for VM-based experimentation
with Node-based coding agents.
