# Notes <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->

- [General Tips \& Tricks](#general-tips--tricks)
- [Configure LSP (Language Server)](#configure-lsp-language-server)
- [Fix Github rate limit with Lazy](#fix-github-rate-limit-with-lazy)
  - [Personal Access Token (PAT)](#personal-access-token-pat)
  - [.netrc file](#netrc-file)

## General Tips & Tricks

- View available colorschemes by opening neovim and running `:Telescope colorscheme`
- Press `<Space>` to open an interactive menu
  - This is the `<Leader>` key.
  - There is also the `<LocalLeader>`, which is `\` in my configs.
- Run `:Lazy` to open the package manager

## Configure LSP (Language Server)

Configuring a language server (LSP) with Lazy and Mason is pretty simple. [Find a language server here](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md), for example the [`marksman` Markdown LSP](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman).

In your [`init.lua`](./config/nvim/init.lua), find the line that begins with `require('lazy').setup({`. Within that function, find the section that begins with the comment `-- Main LSP Configuration`. In that section, in the `config = function()` function, find the variable `local servers = {`.

Configure your LSPs Within the `local servers = {}` mapping, referencing existing LSPs for setup. After finding an LSP from the list, find the setup instructions and the `Default config:` section.

For example, the `marksman` default config looks like:

* `cmd` :
> `{ "marksman", "server" }`
* `filetypes` :
> `{ "markdown", "markdown.mdx" }`
* `root_markers` :
> `{ ".marksman.toml", ".git" }`

To configure a new LSP with Mason, you just need to add some setup instructions:

```lua
-- Markdown https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
marksman =  {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" }
},
```

Next time you run `nvim`, Mason will install the LSP and `neovim` will use it when an appropriate file is opened.

## Fix Github rate limit with Lazy

Github [rate limits unauthenticated requests at 60/hour](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2022-11-28). If you hit this rate limit, Lazy will fail to install/update packages with an error like:

```shell
clone failed
Cloning into 'C:/Users/$USERNAME/AppData/Local/nvim-data/lazy/mason'...
remote: Repository not found.
fatal: repository 'https://github.com/mason-org/mason.git/' not found
```

To fix this, you can configure a [Github Personal Access Token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) and [set it in your environment](#personal-access-token-pat) or a [`.netrc`](#netrc-file) file in your home directory.

### Personal Access Token (PAT)

Set an environment variable `GITHUB_TOKEN` in your environment. You can run one of the commands below to set your token for the current terminal session, but when you close that session the variable will be reset. Add it to your `~/.bashrc` on Linux, or your Windows user's environment.

Temporarily set a token on Linux:

```bash
export GITHUB_TOKEN=ghp_your_personal_access_token
```

Temporarily set a token on Windows:

```powershell
$env:GITHUB_TOKEN = "ghp_your_personal_access_token"
```

To set the environment variable permanently on Windows, you can run:

```powershell
[System.Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "ghp_your_token", "User")
```

### .netrc file

You can also create a `~/.netrc` file with the following contents:

```plaintext
machine github.com
login your_github_username
password ghp_your_personal_access_token
```
