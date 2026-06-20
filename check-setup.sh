#!/usr/bin/env bash
# Run with:  bash check-setup.sh
# Or make executable:  chmod +x check-setup.sh && ./check-setup.sh

# ── colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

PASS=0
FAIL=0

pass()  { echo -e "  ${GREEN}✓${NC} $1"; ((PASS++)); }
fail()  { echo -e "  ${RED}✗${NC} $1"; ((FAIL++)); }
warn()  { echo -e "  ${YELLOW}!${NC} $1"; }
header(){ echo -e "\n${BOLD}── $1 ──${NC}"; }

# Source nvm so it is available even when the script is called without a login shell
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# Source pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &>/dev/null && eval "$(pyenv init -)"

# ── Google Chrome ─────────────────────────────────────────────────────────────
header "Google Chrome"
if [ -d "/Applications/Google Chrome.app" ]; then
  pass "Google Chrome is installed"
else
  fail "Google Chrome not found in /Applications"
fi

# ── Visual Studio Code ────────────────────────────────────────────────────────
header "Visual Studio Code"
if command -v code &>/dev/null; then
  pass "'code' command available: $(code --version 2>/dev/null | head -1)"
else
  fail "'code' command not in PATH — run 'Shell Command: Install code command in PATH' from VS Code"
fi

# ── Xcode CLI Tools ───────────────────────────────────────────────────────────
header "Xcode CLI Tools"
if xcode-select -p &>/dev/null; then
  pass "Xcode CLI tools installed at $(xcode-select -p)"
else
  fail "Xcode CLI tools not installed — run: xcode-select --install"
fi

# ── ZSH ───────────────────────────────────────────────────────────────────────
header "Default Shell"
current_shell="$(dscl . -read /Users/"$USER" UserShell 2>/dev/null | awk '{print $2}')"
if [ "$current_shell" = "/bin/zsh" ]; then
  pass "Default shell is zsh"
else
  fail "Default shell is '$current_shell' (expected /bin/zsh) — run: chsh -s /bin/zsh"
fi

# ── Homebrew ──────────────────────────────────────────────────────────────────
header "Homebrew"
if command -v brew &>/dev/null; then
  pass "brew: $(brew --version 2>/dev/null | head -1)"
else
  fail "Homebrew not installed"
fi

# ── Git ───────────────────────────────────────────────────────────────────────
header "Git"
if command -v git &>/dev/null; then
  pass "git: $(git --version)"
else
  fail "git not installed"
fi

git_name="$(git config --global user.name 2>/dev/null)"
git_email="$(git config --global user.email 2>/dev/null)"
git_branch="$(git config --global init.defaultBranch 2>/dev/null)"
git_cred="$(git config --global credential.helper 2>/dev/null)"

[ -n "$git_name" ]             && pass "git user.name: $git_name"         || fail "git user.name not set"
[ -n "$git_email" ]            && pass "git user.email: $git_email"       || fail "git user.email not set"
[ "$git_branch" = "main" ]     && pass "git init.defaultBranch: main"     || fail "git init.defaultBranch is '$git_branch' (expected: main)"
[[ "$git_cred" == *osxkeychain* ]] && pass "GitHub credential helper: osxkeychain" \
                                   || warn "credential.helper is '$git_cred' — consider running: git config --global credential.helper osxkeychain"

# ── rbenv & Ruby ─────────────────────────────────────────────────────────────
header "rbenv & Ruby"
EXPECTED_RUBY="3.4.9"
EXPECTED_RAILS="8.1.3"

if command -v rbenv &>/dev/null; then
  pass "rbenv: $(rbenv --version)"
else
  fail "rbenv not installed"
fi

ruby_ver="$(ruby --version 2>/dev/null)"
if echo "$ruby_ver" | grep -q "$EXPECTED_RUBY"; then
  pass "ruby: $ruby_ver"
else
  fail "ruby: found '${ruby_ver:-not found}' — expected $EXPECTED_RUBY"
fi

for gem_name in bundler pry byebug; do
  gem list --local "$gem_name" 2>/dev/null | grep -q "^$gem_name " \
    && pass "gem $gem_name installed" \
    || fail "gem $gem_name not installed — run: gem install $gem_name"
done

rails_ver="$(rails --version 2>/dev/null)"
if echo "$rails_ver" | grep -q "$EXPECTED_RAILS"; then
  pass "rails: $rails_ver"
else
  fail "rails: found '${rails_ver:-not found}' — expected Rails $EXPECTED_RAILS"
fi

# ── PostgreSQL & SQLite ───────────────────────────────────────────────────────
header "PostgreSQL & SQLite"
if command -v psql &>/dev/null; then
  pass "psql: $(psql --version)"
else
  fail "psql not in PATH — ensure Postgres.app is installed and its bin path is in /etc/paths.d/postgresapp"
fi

if command -v sqlite3 &>/dev/null; then
  pass "sqlite3: $(sqlite3 --version | awk '{print $1}')"
else
  fail "sqlite3 not installed — run: brew install sqlite"
fi

# ── nvm & Node.js ─────────────────────────────────────────────────────────────
header "nvm & Node.js"
EXPECTED_NODE_MAJOR="24"

if command -v nvm &>/dev/null; then
  pass "nvm: $(nvm --version)"
else
  fail "nvm not loaded — verify the nvm startup lines are in ~/.zshrc"
fi

node_ver="$(node --version 2>/dev/null)"
node_major="$(echo "$node_ver" | sed 's/v\([0-9]*\).*/\1/')"
if [ "$node_major" = "$EXPECTED_NODE_MAJOR" ]; then
  pass "node: $node_ver"
else
  fail "node: found '${node_ver:-not found}' — expected v${EXPECTED_NODE_MAJOR}.x.x (run: nvm install $EXPECTED_NODE_MAJOR)"
fi

if command -v mocha &>/dev/null; then
  pass "mocha: $(mocha --version)"
else
  fail "mocha not installed — run: npm install -g mocha"
fi

# ── pyenv & Python ────────────────────────────────────────────────────────────
header "pyenv & Python"
EXPECTED_PYTHON="3.14.6"

if command -v pyenv &>/dev/null; then
  pass "pyenv: $(pyenv --version)"
else
  fail "pyenv not installed or not in PATH"
fi

python_ver="$(python --version 2>/dev/null || python3 --version 2>/dev/null)"
if echo "$python_ver" | grep -q "$EXPECTED_PYTHON"; then
  pass "python: $python_ver"
else
  fail "python: found '${python_ver:-not found}' — expected Python $EXPECTED_PYTHON"
fi

if command -v pipenv &>/dev/null; then
  pass "pipenv: $(pipenv --version)"
else
  fail "pipenv not installed — run: pip install pipenv"
fi

# ── Go ───────────────────────────────────────────────────────────────────────
header "Go"
export PATH="$HOME/go/bin:$PATH"

if command -v go &>/dev/null; then
  pass "go: $(go version)"
else
  fail "go not installed — run: brew install go"
fi

if echo "$PATH" | grep -q "$HOME/go/bin"; then
  pass "\$HOME/go/bin is in PATH"
else
  warn "\$HOME/go/bin not in PATH — add to ~/.zshrc: export PATH=\"\$HOME/go/bin:\$PATH\""
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ "$FAIL" -eq 0 ]; then
  echo -e "${GREEN}${BOLD}✓ All $PASS checks passed — your setup is complete!${NC}"
else
  echo -e "${RED}${BOLD}✗ $FAIL check(s) failed  /  $PASS passed${NC}"
  echo -e "Fix the items marked ${RED}✗${NC} above, then run this script again."
fi
echo ""
