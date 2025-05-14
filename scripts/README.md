# Scripts

Scripts for installing & configuring neovim.

Use the setup script for your platform:

- [Windows](./windows/install-neovim-win.ps1)
- [Windows LSP](./windows/install-lsp-requirements.ps1)
  - On Windows, Mason does not properly install LSPs for some reason. This script installs the ones Neovim has trouble with.
- [Linux](./linux/install.sh)
  - **Note**: Currently only RedHat and Debian family OSes are supported. This script is untested for Mac, Arch, Alpine, Nix, etc.
  - The Linux install script detects your OS and release and sets the package manager for you.
  - The script will install all dependencies using `apt`, `dnf,` etc.
  - On RedHat family OSes, if `dnf` is not found, the script will fall back to `yum`.
