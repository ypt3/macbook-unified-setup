# macbook-unified-setup

A unified macOS development environment setup guide and verification script for Intel Macs running macOS Mojave or newer.

## What's included

| File | Purpose |
|---|---|
| `setup.md` | Step-by-step installation guide |
| `check-setup.sh` | Automated verification script |

## Tools installed

The guide walks you through installing and configuring:

- **Browser & Editor** — Google Chrome, Visual Studio Code
- **Shell** — Xcode CLI Tools, ZSH, Oh My Zsh
- **Package manager** — Homebrew
- **Version control** — Git, GitHub authentication (PAT via macOS Keychain)
- **Ruby** — rbenv, Ruby 3.4.9, Bundler, Pry, Byebug, Rails 8.1.3
- **Databases** — PostgreSQL (Postgres.app), SQLite
- **JavaScript** — nvm, Node.js 24 (LTS), Mocha
- **Python** — pyenv, Python 3.14.6, Pipenv
- **Go** — Go (via Homebrew)
- **Cloud CLIs** — AWS CLI, GCP CLI (`gcloud`)
- **Infrastructure** — Terraform, Vagrant

## Usage

### 1. Follow the setup guide

Open [`setup.md`](setup.md) and install each tool in order. The guide includes copy-paste shell commands for every step.

### 2. Verify your setup

After completing the guide, run the checker script:

```shell
bash check-setup.sh
```

Each item prints a green `✓` (pass) or red `✗` (fail) with a hint on how to fix it. Re-run until all checks pass.

## Requirements

- Mac with an **Intel** chip (not Apple Silicon/M1/M2)
- macOS Mojave (10.14) or newer

> For Apple Silicon Macs, follow the separate Apple Silicon Setup guide instead.

## License

[MIT](LICENSE)
