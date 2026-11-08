# Main Config

My main/default Neovim configuration. All configuration is in a single [`init.lua`](./init.lua). Plugins are installed and configured using the [`plugins.lua` file](./plugins.lua). This file is separate to allow disabling plugins by setting `NVIM_DISABLE_PLUGINS=1`.

The configuration will also look for a `~/.config/nvim/init.local.lua` file to source local, per-machine overrides.

> [!WARNING]
> No special care or attention has been given to make this compatible with Windows. For the best experience, install the configuration(s) in WSL and run Neovim there.

## Requirements

- Neovim 0.12+
- `git`
- `curl`
- `tar`, `gzip`, `unzip`
- C complier, i.e. GCC or Clang
- `tree-sitter-cli` executable
  - `brew install tree-sitter-cli`
  - `mise use tree-sitter@latest`

Optional:

| Dependency            | Enables                                                                      | Behavior without it                                                                                            |
| --------------------- | ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Node.js and `npm`     | Node-based language servers: Bash, Pyright, Dockerfile, Docker Compose, YAML | Skip automatic installation and activation of those servers.                                                   |
| Go                    | Go-based language servers                                                    | Skip `gopls` and, conservatively, `sqls`.                                                                      |
| PowerShell 7 (`pwsh`) | PowerShell Editor Services and your optional Windows shell selection         | Skip `powershell_es`                                                                                           |
| Rust / `cargo`        | Crate installation, compiling Rust apps                                      | N/a                                                                                                            |
| ripgrep (`rg`)        | Telescope content search                                                     | Grep mappings and “Grep project” starter item will not work.                                                   |
| `fd`                  | Improved filename discovery; repository discovery through `repo.list()`      | Telescope can use other filename finders.                                                                      |
| Clipboard backend     | System clipboard integration                                                 | `unnamedplus` and system-clipboard mappings cannot provide the intended integration without a working backend. |

## Local override

When using this configuration, you can place a file named `init.local.lua` in the same path as the configuration (default: `~/.config/nvim-minimal/`). Any plugins or options defined here will be sourced in addition to the `init.lua`, and will override options set in `init.lua`. This can be useful for overriding specific settings on specific machines, i.e. installing a different set of plugins on a work machine.
