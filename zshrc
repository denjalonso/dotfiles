#!/bin/zsh
# zshrc → ~/.zshrc — Denis J. Alonso
# Base: https://github.com/kentcdodds/dotfiles (depurado en oct 2026).
#
# Este archivo va al repo y es igual en todos los Macs. Lo que cambia por
# máquina vive fuera del repo y se carga al final:
#   ~/.zshrc.private  → secretos (API keys, tokens). chmod 600. NUNCA al repo.
#   ~/.zshrc.local    → cosas de ESTE Mac (alias de proyectos, SDKMAN, etc.)

export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Fafacxdxbxegedabagacad

# Homebrew (Apple Silicon). Primero en el PATH para que nunca gane /usr/local.
eval "$(/opt/homebrew/bin/brew shellenv)"

###############################################################################
# PROMPT: directorio + rama git + emoji aleatorio
###############################################################################
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

git_branch() {
  git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \(\1\)/'
}

random_element() {
  declare -a array=("$@")
  r=$((RANDOM % ${#array[@]}))
  printf "%s\n" "${array[$r]}"
}

setEmoji() {
  EMOJI="$*"
  DISPLAY_DIR='$(dirs)'
  DISPLAY_BRANCH='$(git_branch)'
  PROMPT="${YELLOW}${DISPLAY_DIR}${GREEN}${DISPLAY_BRANCH}${RESET} ${EMOJI}"$'\n'"$ "
}

newRandomEmoji() {
  setEmoji "$(random_element 😅 👽 🔥 🚀 👻 ⛄ 👾 🍔 😄 🍰 🐑 😎 🏎 🤖 😇 😼 💪 🦄 🥓 🌮 🎉 💯 ⚛️ 🐠 🐳 🐿 🥳 🤩 🤯 🤠 👨‍💻 🦸‍ 🧝‍ 🧞‍ 🧙‍ 🧑‍🚀 👨‍🔬 🕺 🦁 🐶 🐵 🐻 🦊 🐙 🦎 🦖 🦕 🦍 🦈 🐊 🦂 🐍 🐢 🐘 🐉 🦚 ✨ ☄️ ⚡️ 💥 💫 🧬 🔮 ⚗️ 🎊 🔭 ⚪️ 🔱)"
}

newRandomEmoji
setopt promptsubst

# Prompts "temáticos" (de Kent)
alias nodeify="PS1=\"💥\"$'\n'\"$ \""
alias reactify="PS1=\"⚛️\"$'\n'\"$ \""
alias jestify="PS1=\"🃏\"$'\n'\"$ \""
alias harryify="PS1=\"🧙‍\"$'\n'\"$ \""

###############################################################################
# HISTORIAL
###############################################################################
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS

###############################################################################
# PATH
###############################################################################
# binarios locales del proyecto
PATH="$PATH:./node_modules/.bin"
# bins propios
PATH="$PATH:$HOME/.bin:$HOME/.local/bin"
# Node vía n (https://github.com/tj/n). N_PREFIX fuera de /usr/local → sin sudo.
export N_PREFIX="$HOME/n"
[[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH="$N_PREFIX/bin:$PATH"
# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
[[ :$PATH: == *":$PNPM_HOME:"* ]] || PATH="$PNPM_HOME:$PATH"
# clientes de BD keg-only de brew (solo si están instalados)
[ -d /opt/homebrew/opt/libpq/bin ] && PATH="/opt/homebrew/opt/libpq/bin:$PATH"
[ -d /opt/homebrew/opt/mysql-client/bin ] && PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH

# cd sin ruta completa desde cualquier sitio
CDPATH=.:$HOME:$HOME/Projects:$HOME/code:$HOME/Desktop

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export NODE_OPTIONS="--dns-result-order=ipv4first"
export SCARF_ANALYTICS=false

###############################################################################
# ALIAS
###############################################################################
# editores
c() { code "${@:-.}"; }
i() { idea "${@:-.}"; }        # `idea` lo instala JetBrains Toolbox (Settings → Shell scripts)
alias cz="code ~/.zshrc"
alias vz="vim ~/.zshrc"
alias sz="source ~/.zshrc"

# navegación
alias ll="ls -1a"
alias ..="cd ../"
alias ..l="cd ../ && ll"
alias de="cd ~/Desktop"
alias d="cd ~/code"
alias projects="cd ~/Projects"

# sistema
alias pg="echo 'Pinging Google' && ping www.google.com"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias deleteDSFiles="find . -name '.DS_Store' -type f -delete"
alias dont_index_node_modules='find . -type d -name "node_modules" -exec touch "{}/.metadata_never_index" \;'
alias check-nodemon="ps aux | rg -i '.bin/nodemon'"

# pomodoro (brew: caarlos0/tap/timer + terminal-notifier)
alias work="timer 25m && terminal-notifier -message 'Pomodoro' -title 'Work Timer is up! Take a Break 😊' && afplay /System/Library/Sounds/Glass.aiff"
alias rest="timer 5m && terminal-notifier -message 'Pomodoro' -title 'Break is over! Get back to work 😬' && afplay /System/Library/Sounds/Glass.aiff"

# git
gc() { git commit -m "$@"; }
alias gs="git status"
alias gp="git pull"
alias gf="git fetch"
alias gpush="git push"
alias gd="git diff"
alias ga="git add ."
dif() { git diff --no-index "$1" "$2"; }   # pasa por delta (ver .gitconfig)
cdiff() { code --diff "$1" "$2"; }

# npm
alias ni="npm install"
alias nrs="npm run start -s --"
alias nrb="npm run build -s --"
alias nrd="npm run dev -s --"
alias nrt="npm run test -s --"
alias nrtw="npm run test:watch -s --"
alias nrv="npm run validate -s --"
alias rmn="rm -rf node_modules"
alias flush-npm="rm -rf node_modules package-lock.json && npm i && say NPM is done"
alias nicache="npm install --prefer-offline"
alias nioff="npm install --offline"
alias npm-update="npx npm-check-updates --dep prod,dev --upgrade"

# yarn / pnpm
alias yar="yarn run"
alias yas="yarn run start"
alias yab="yarn run build"
alias yat="yarn run test"
alias yarn-update="yarn upgrade-interactive --latest"
alias pn="pnpm"

###############################################################################
# FUNCIONES
###############################################################################
mg() { mkdir -p "$@" && cd "$@" || exit; }
cdl() { cd "$@" && ll; }
npm-latest() { npm info "$1" | grep latest; }
killport() { lsof -i tcp:"$*" | awk 'NR!=1 {print $2}' | xargs kill -9; }

quit() {
  if [ -z "$1" ]; then
    echo "Usage: quit appname"
  else
    for appname in "$@"; do
      osascript -e 'quit app "'"$appname"'"'
    done
  fi
}

# vídeo → gif (brew: ffmpeg imagemagick)
gif() {
  ffmpeg -i "$1" -vf "fps=25,scale=iw/2:ih/2:flags=lanczos,palettegen" -y "/tmp/palette.png"
  ffmpeg -i "$1" -i "/tmp/palette.png" -lavfi "fps=25,scale=iw/2:ih/2:flags=lanczos [x]; [x][1:v] paletteuse" -f image2pipe -vcodec ppm - | convert -delay 4 -layers Optimize -loop 0 - "${1%.*}.gif"
}

###############################################################################
# COMPLETION
###############################################################################
FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

###############################################################################
# POR MÁQUINA (fuera del repo)
###############################################################################
[ -f "$HOME/.zshrc.private" ] && source "$HOME/.zshrc.private"
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
