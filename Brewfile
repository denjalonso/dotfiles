# Brewfile — común a todos los Macs.  `brew bundle --file=Brewfile`
# Lo personal (Spotify, WhatsApp, GoPro…) está en Brewfile.personal.
# Las líneas comentadas con "# ?" son cosas que tenías en el M1 y no sé si
# sigues usando: descoméntalas o bórralas.

tap "caarlos0/tap"          # timer (pomodoro)
tap "stripe/stripe-cli"

# --- CLI básico ---------------------------------------------------------------
brew "git"
brew "gh"
brew "git-delta"            # diffs bonitos (ver .gitconfig)
brew "git-lfs"
brew "ripgrep"
brew "bat"
brew "tree"
brew "jq"
brew "wget"
brew "coreutils"
brew "gnu-sed"
brew "tldr"
brew "zsh-completions"
brew "mas"                  # App Store desde terminal
brew "watchman"
brew "imagemagick"
brew "ffmpeg"
brew "switchaudio-osx"
brew "terminal-notifier"
brew "caarlos0/tap/timer"
brew "gnupg"

# --- Node / JS ----------------------------------------------------------------
brew "n"                    # versiones de Node (N_PREFIX=~/n en .zshrc)
brew "pnpm"
brew "yarn"

# --- Bases de datos (clientes) -----------------------------------------------
brew "libpq"                # psql sin servidor postgres
brew "pgcli"
brew "mysql-client"
# brew "postgresql@16"      # ? servidor local; en el M3 quizá mejor Docker
# brew "mongodb-community"  # ?

# --- Cloud / infra ------------------------------------------------------------
brew "awscli"
brew "cloudflared"
brew "act"                  # GitHub Actions en local
brew "actionlint"
brew "stripe/stripe-cli/stripe"
# brew "terraform"          # ?
# brew "kubernetes-cli"     # ?
# brew "helm"               # ?

# --- Java (solo si lo necesitas fuera de IntelliJ) ----------------------------
# brew "openjdk"            # ?
# brew "gradle"             # ?
# brew "maven"              # ?
# brew "kotlin"             # ?

# --- Otros --------------------------------------------------------------------
# brew "rbenv"              # ?
# brew "ruby-build"         # ?
# brew "whisper.cpp"        # ?
# brew "rclone"             # ?

# --- Apps: terminal y editores -----------------------------------------------
cask "iterm2"
cask "visual-studio-code"
cask "superset"            # terminal para agentes (superset.sh)
# cask "cursor"             # lo que usa Kent ahora; opcional
cask "jetbrains-toolbox"    # IntelliJ IDEA + comando `idea`
cask "sublime-text"

# --- Apps: desarrollo ---------------------------------------------------------
cask "docker-desktop"       # necesario para Docker Sandboxes (no vale OrbStack)
cask "postman"
cask "dbeaver-community"
cask "mongodb-compass"
cask "claude"
cask "chatgpt"
cask "runjs"

# --- Apps: productividad ------------------------------------------------------
cask "raycast"
cask "1password"
cask "1password-cli"
cask "karabiner-elements"
cask "the-unarchiver"
cask "obsidian"
cask "notion"
cask "deepl"
cask "pdf-expert"
cask "grammarly-desktop"
cask "wispr-flow"

# --- Apps: navegadores y comunicación -----------------------------------------
cask "google-chrome"
cask "firefox"
cask "brave-browser"
cask "slack"
cask "discord"
cask "linear-linear"

# --- Apps: red / acceso remoto ------------------------------------------------
cask "logi-options+"

# --- Apps: certificados / administración española -----------------------------
cask "autofirma"
# Configurador FNMT: https://www.sede.fnmt.gob.es/descargas/descarga-software (no hay cask)

# --- Apps: multimedia ---------------------------------------------------------
cask "vlc"
# cask "cap"                # grabador de pantalla simple (lo usa Kent)

# --- App Store ----------------------------------------------------------------
# mas "Xcode", id: 497799835
# mas "Be Focused", id: 973134470
