# macOS Development Setup

> **Note:** These instructions are for Macs **without** an Apple Silicon (M1/M2) chip. To check, go to Apple menu → `About This Mac`. If you see `Chip: Apple`, follow the `Apple Silicon Setup` instead.

You need to be running macOS Mojave or newer. Install all software below **in order**.

---

## Google Chrome

1. Navigate to the [Google Chrome Download] page in your current browser.
2. Download and run the installer.
3. When prompted, set Google Chrome as your default browser.

[Google Chrome Download]: https://www.google.com/chrome/

---

## Visual Studio Code

1. Navigate to the [VS Code Download] page in Chrome.
2. Download and run the Mac installer.
3. Drag the VS Code app icon into your Applications folder.
4. Open VS Code, then open the Command Palette (`Cmd+Shift+P`).
5. Type `shell command` and select **Shell Command: Install 'code' command in PATH**.

[VS Code Download]: https://code.visualstudio.com/Download

---

## Xcode CLI & ZSH

1. Run the following in your terminal:

   ```shell
   xcode-select --install
   chsh -s /bin/zsh
   ```

2. Restart your terminal to complete the transition to ZSH.

---

## Homebrew & Git

1. Install Homebrew and `git`:

   ```shell
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
   brew install git
   ```

2. Configure `git` (replace the placeholder values with your actual name and email):

   ```shell
   git config --global user.name "Your Name"
   git config --global user.email "Your Email"
   git config --global init.defaultBranch main
   ```

3. Verify the configuration:

   ```shell
   git config user.name
   git config user.email
   ```

   Both should print your name and email. If either is blank, repeat step 2.

4. Check Homebrew for any problems:

   ```shell
   brew doctor
   ```

   It should print `Your system is ready to brew.`

---

## GitHub Authentication

GitHub uses a **Personal Access Token (PAT)** instead of your account password for git operations over HTTPS.

### Set up the macOS Keychain credential helper

Tell git to store your PAT in the macOS Keychain so you only enter it once:

```shell
git config --global credential.helper osxkeychain
```

### Generate a Personal Access Token

1. Go to [GitHub → Settings → Developer settings → Personal access tokens][PAT] and click **Generate new token (classic)**.
2. Give it a descriptive name (e.g., the name of your Mac).
3. Set an expiration and enable at minimum all **repo** permissions.
4. Click **Generate token** — copy it immediately, it is only shown once.

### Save the token

Run any authenticated git command (e.g., cloning a private repo). When prompted for a password, paste your PAT. macOS Keychain will save it automatically — you won't be prompted again on this machine.

> If you already use SSH keys for GitHub, you can skip this section. See the [SSH setup guide][SSH article] if you need help troubleshooting SSH.

[PAT]: https://github.com/settings/tokens
[SSH article]: https://hackmd.io/@AgDXdHgSSPKsJIhCxlaTuA/BJtNu88fF

---

## rbenv & Ruby

1. Install `rbenv`:

   ```shell
   brew install rbenv
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
   echo 'eval "$(rbenv init -)"' >> ~/.zshrc
   source ~/.zshrc
   ```

2. Install Ruby and the required gems:

   ```shell
   rbenv install 3.4.9
   rbenv global 3.4.9
   rbenv rehash
   gem install bundler pry byebug
   gem install rails -v 8.1.3
   rbenv rehash
   ```

   > If the Rails install throws an error, run `brew install shared-mime-info` and try again.

---

## PostgreSQL & SQLite

1. Navigate to the [Postgres.app Download] page and download the Latest Release installer.
2. Run the installer, then expose the CLI tools and install SQLite:

   ```shell
   sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
   brew install sqlite
   ```

3. Restart your terminal to complete the installation.

[Postgres.app Download]: https://postgresapp.com/downloads.html

---

## nvm & Node.js

Node.js is a JavaScript runtime for running JavaScript outside the browser. Rather than installing it directly from nodejs.org, you use **Node Version Manager (nvm)** so you can switch between versions per project.

> Do **not** install Node.js from the nodejs.org website. If you already have that version installed, uninstall it first.

### Install nvm

1. Run the following command:

   ```shell
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
   ```

2. The installer attempts to add startup lines to your shell file automatically, but **verify this yourself**. Open your shell startup file:

   ```shell
   code ~/.zshrc
   ```

   Confirm it contains these lines (add them if missing):

   ```shell
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
   ```

3. Reload your shell:

   ```shell
   source ~/.zshrc
   ```

   Running `nvm` alone should now print nvm's help output.

### Install Node.js

Install and activate the current LTS version used in this course:

```shell
nvm install 24
nvm use 24
```

Verify the installation:

```shell
node --version   # should print v24.x.x
which node       # should print a path containing .nvm
```

> Only use **LTS (Long Term Support)** versions of Node.js — these are even-numbered releases (20, 22, 24…). Odd-numbered releases are experimental. Node.js 24 is the current Active LTS as of 2026.

### Install Mocha

Mocha is the testing framework used for JavaScript projects and assessments.

```shell
npm install -g mocha
```

Verify it works:

```shell
mocha --version
```

> `npm` and `nvm` are different tools. `nvm` manages Node.js versions; `npm` installs JavaScript packages.

---

## pyenv & Python

Python is the second programming language used in this course. Like nvm for Node.js, **pyenv** manages Python versions on your system.

> Do **not** install Python from python.org. If you have that version installed, uninstall it first.

### Install pyenv

1. Run the following command:

   ```shell
   curl https://pyenv.run | bash
   ```

2. Unlike nvm, pyenv does **not** automatically update your shell startup file. Open it manually:

   ```shell
   code ~/.zshrc
   ```

   Add these lines:

   ```shell
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   eval "$(pyenv init -)"
   eval "$(pyenv init --path)"
   ```

3. Restart your terminal to apply the changes.

### Install Python

Install Python 3.14.6 (pyenv requires the exact version number):

```shell
pyenv install 3.14.6
pyenv global 3.14.6
```

Close and reopen your terminal, then verify:

```shell
python --version    # should print Python 3.14.6
python3 --version   # should also print Python 3.14.6
```

### Install Pipenv

Pipenv manages per-project Python dependencies.

```shell
pip install pipenv
```

Then add the following line to `~/.zshrc`, **after** the `eval "$(pyenv init --path)"` line:

```shell
export PIPENV_VENV_IN_PROJECT=1
```

---

## Go

Go is installed via Homebrew, which you already have from the earlier step.

### Install Go

```shell
brew install go
```

### Verify the installation

```shell
go version   # should print go version go1.x.x darwin/amd64
```

### Configure your Go workspace

Go uses a workspace directory at `~/go` by default. Add the Go binary path to your shell so tools installed with `go install` are available:

```shell
echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

You're all set! All required languages, runtimes, and tools are now installed.

---

## Verify your setup

Run the setup checker to confirm everything is installed and configured correctly:

```shell
bash check-setup.sh
```

Each item will print a green `✓` (pass) or red `✗` (fail) with a hint on how to fix it. Fix any failures and re-run until all checks pass.
