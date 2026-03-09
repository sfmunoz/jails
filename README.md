# jails

Isolated environments for AI coding agents.

**jails** is meant to provided ready-to-use configurations to run AI coding tools (Claude Code, OpenCode, ...) inside confined environments — Docker containers, Vagrant VMs, and others — scoped to specific language stacks (Go, Node, Python, ...).

## Rationale

AI coding agents need filesystem access, network access and the ability to run commands. Giving them unrestricted access to your host machine is a risk. Jails contains the blast radius.

## Structure

Configurations are organized across three dimensions:

- **Runtime** — how the jail is created (Docker, Vagrant, ...)
- **Tool** — the AI coding agent running inside (Claude Code, OpenCode, ...)
- **Stack** — the language/ecosystem available (Go, Node, Python, ...)

```
jails/
├── base/          # hardened base images, shared across tools and stacks
├── tools/         # per-tool configurations, layered on top of base
└── scripts/       # build and management helpers
```

## Status

Early stages of the project.
