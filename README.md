# dotfiles

Configuración de terminal y tooling de Denis. Un solo repo para el Mac personal
y el del trabajo; lo que cambia por máquina vive fuera del repo.

Base original: [kentcdodds/dotfiles](https://github.com/kentcdodds/dotfiles)
(remote `upstream`, por si quiero mirar qué cambia). Reescrito en oct 2026.

## Mac nuevo

```sh
xcode-select --install
git clone https://github.com/denjalonso/dotfiles.git ~/dotfiles   # https: aún no hay SSH
cd ~/dotfiles
./install.sh              # Mac del trabajo
./install.sh --personal   # Mac personal (añade Brewfile.personal)
```

`install.sh` es idempotente: instala Homebrew y el `Brewfile`, enlaza los
dotfiles al `$HOME` (haciendo backup de lo que hubiera), crea los archivos
por máquina, instala Node con `n`, genera la clave SSH y aplica unos pocos
`defaults` de macOS. Después, cambia el remote a SSH:
`git remote set-url origin git@github.com:denjalonso/dotfiles.git`.

## Qué hay

| En el repo                         | Enlazado a                         |
| ---------------------------------- | ---------------------------------- |
| `zshrc`                            | `~/.zshrc`                         |
| `gitconfig`, `.gitignore_global`   | `~/.gitconfig`, `~/.gitignore_global` |
| `.ripgreprc`                       | `~/.ripgreprc`                     |
| `.vimrc`, `.vimrc-parts/`          | `~/.vimrc`, `~/.vimrc-parts`       |
| `.config/bat/config`               | `~/.config/bat/config`             |
| `.config/ccstatusline/settings.json` | `~/.config/ccstatusline/settings.json` |
| `.claude/*`                        | `~/.claude/*` (statusline de Claude Code) |
| `Brewfile`, `Brewfile.personal`    | —                                  |
| `zshrc.local.example`              | plantilla de `~/.zshrc.local`      |

## Qué NO hay (por máquina, nunca al repo)

| Archivo              | Contenido                                            |
| -------------------- | ---------------------------------------------------- |
| `~/.zshrc.private`   | API keys y tokens (`chmod 600`)                      |
| `~/.zshrc.local`     | alias de proyectos, SDKMAN, variables de este Mac    |
| `~/.gitconfig.local` | `user.name` / `user.email` (personal vs. trabajo)    |

## Mantenerlo al día

- Nueva herramienta → añadirla al `Brewfile` (`brew bundle dump` ayuda a ver
  qué tienes instalado que no está).
- Nuevo alias → `.zshrc` si vale para los dos Macs, `~/.zshrc.local` si no.
- `cd ~/dotfiles && git pull && ./install.sh` en el otro Mac.
