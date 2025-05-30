package main

import (
	"github.com/redjax/neovim/packages/project_cli/cmd/cli/download"
	"github.com/spf13/cobra"
)

func main() {
	rootCmd := &cobra.Command{Use: "cli"}
	rootCmd.AddCommand(download.NewDownloadCmd())
	rootCmd.Execute()
}
