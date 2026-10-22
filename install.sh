#!/usr/bin/env bash
# install.sh — deja un Mac nuevo listo. Idempotente: se puede relanzar.
#
#   git clone git@github.com:denjalonso/dotfiles.git ~/dotfiles
#   cd ~/dotfiles && ./install.sh              # Mac del trabajo
#   cd ~/dotfiles && ./install.sh --personal   # Mac personal (+ Brewfile.personal)
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSONAL=0
[[ "${1:-}" == "--personal" ]] && PERSONAL=1

say() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# ------------------------------------------------------------------ Xcode CLT
if ! xcode-select -p >/dev/null 2>&1; then
  say "Instalando Xcode Command Line Tools (acepta el diálogo y relanza el script)"
  xcode-select --install
  exit 0
fi

# ------------------------------------------------------------------- Homebrew
if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
  say "Instalando Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

say "brew bundle (Brewfile)"
brew bundle --file="$DOTFILES/Brewfile" || true
if [ "$PERSONAL" = 1 ]; then
  say "brew bundle (Brewfile.personal)"
  brew bundle --file="$DOTFILES/Brewfile.personal" || true
fi

# ------------------------------------------------------------------- symlinks
# link <ruta relativa en el repo> <destino en $HOME>
# Si el destino existe y no es un enlace, se guarda como *.backup.<fecha>.
link() {
  local src="$DOTFILES/$1" dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.backup.$(date +%Y%m%d%H%M%S)"
  fi
  ln -sfn "$src" "$dst"
  printf '  %s → %s\n' "~/$2" "$1"
}

say "Enlazando dotfiles"
link zshrc                          .zshrc
link gitconfig                      .gitconfig
link .gitignore_global              .gitignore_global
link .ripgreprc                     .ripgreprc
link .vimrc                         .vimrc
link .vimrc-parts                   .vimrc-parts
link .config/bat/config             .config/bat/config
link .config/ccstatusline/settings.json .config/ccstatusline/settings.json
link .claude/settings.json          .claude/settings.json
link .claude/statusline-command.sh  .claude/statusline-command.sh
link .claude/statusline-wrapper.sh  .claude/statusline-wrapper.sh
chmod +x "$DOTFILES"/.claude/*.sh

# --------------------------------------------------- archivos por máquina
say "Archivos por máquina (fuera del repo)"
if [ ! -f "$HOME/.zshrc.private" ]; then
  : > "$HOME/.zshrc.private"
  chmod 600 "$HOME/.zshrc.private"
  echo "  creado ~/.zshrc.private (secretos; vacío)"
fi
if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$DOTFILES/zshrc.local.example" "$HOME/.zshrc.local"
  echo "  creado ~/.zshrc.local desde zshrc.local.example"
fi
if [ ! -f "$HOME/.gitconfig.local" ]; then
  read -rp "  git user.name  [Denis J. Alonso]: " GIT_NAME
  read -rp "  git user.email: " GIT_EMAIL
  cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = ${GIT_NAME:-Denis J. Alonso}
	email = ${GIT_EMAIL}
EOF
  echo "  creado ~/.gitconfig.local"
fi

# -------------------------------------------------------------- bat theme
if [ ! -d "$HOME/.config/bat/themes/night-owlish" ]; then
  say "Tema night-owlish para bat/delta"
  mkdir -p "$HOME/.config/bat/themes"
  git clone -q https://github.com/batpigandme/night-owlish "$HOME/.config/bat/themes/night-owlish"
  bat cache --build >/dev/null
fi

# ------------------------------------------------------------------- Node
say "Node vía n"
export N_PREFIX="$HOME/n"
export PATH="$N_PREFIX/bin:$PATH"
n install 22 >/dev/null
n install 24
echo "  node $(node -v) / npm $(npm -v)"

say "npm globales"
npm install -g serve turbo vercel json-server npm-check-updates ccstatusline @anthropic-ai/claude-code

# -------------------------------------------------------------------- SSH
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  say "Clave SSH"
  EMAIL="$(git config --file "$HOME/.gitconfig.local" user.email)"
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$HOME/.ssh/id_ed25519"
  mkdir -p "$HOME/.ssh"
  if ! grep -q "AddKeysToAgent" "$HOME/.ssh/config" 2>/dev/null; then
    printf 'Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_ed25519\n' >> "$HOME/.ssh/config"
  fi
  ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"
  pbcopy < "$HOME/.ssh/id_ed25519.pub"
  echo "  clave pública copiada al portapapeles → https://github.com/settings/keys"
fi

# ------------------------------------------------------------- macOS tweaks
say "Ajustes de macOS"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.dock autohide -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.screencapture location -string "$HOME/Desktop"
killall Finder Dock 2>/dev/null || true

say "Listo. Pendiente a mano:"
cat <<'EOF'
  - Abrir iTerm2 y, si quieres, importar el perfil (Preferences → General → Load from ~/dotfiles/iterm2)
  - JetBrains Toolbox → Settings → Shell scripts → habilitar (da el comando `idea`)
  - gh auth login
  - Docker Desktop → arrancar una vez y aceptar
  - 1Password, Raycast, Karabiner: iniciar sesión / dar permisos de accesibilidad
  - Pegar en ~/.zshrc.private las API keys que necesites
  - Abrir una terminal nueva (o `source ~/.zshrc`)
EOF
