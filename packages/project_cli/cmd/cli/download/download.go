package download

import (
	"context"
	"fmt"
	"os"
	"path/filepath"

	"time"

	"github.com/redjax/neovim/packages/project_cli/internal/downloader"
	"github.com/redjax/neovim/packages/project_cli/internal/githubapi"
	"github.com/spf13/cobra"
)

func NewDownloadCmd() *cobra.Command {
	var configName string
	var outputDir string

	cmd := &cobra.Command{
		Use:   "download config --name <config-name>",
		Short: "Download a configuration archive from the latest Github release",
		Run: func(cmd *cobra.Command, args []string) {
			if configName == "" {
				fmt.Println("Please specify a config --name")
				os.Exit(1)
			}

			// Check if config already exists locally
			// configPath := filepatah.Join("config", configName)
			// info, err := os.Stat(configPath)
			// if err != nil || !info.IsDir() {
			// 	fmt.Printf("[ERROR] Config '%s' does not exist in ./config/\n", configName)

			// 	os.Exit(1)
			// }

			ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
			defer cancel()

			releaseURL, archiveName, err := githubapi.GetLatestReleaseAsset(ctx, "redjax", "neovim", configName)
			if err != nil {
				fmt.Println("[ERROR]", err)
				os.Exit(1)
			}

			outPath := filepath.Join(outputDir, archiveName)
			fmt.Printf("Downloading %s to %s\n", releaseURL, outPath)
			if err := downloader.DownloadFile(ctx, releaseURL, outPath); err != nil {
				fmt.Println("[ERROR] Download failed:", err)
				os.Exit(1)
			}
			fmt.Printf("[SUCCESS] Downloaded %s\n", outPath)
		},
	}

	cmd.Flags().StringVar(&configName, "name", "", "Config name (required)")
	cmd.Flags().StringVar(&outputDir, "output", ".", "Output directory")
	cmd.MarkFlagRequired("name")

	return cmd
}
