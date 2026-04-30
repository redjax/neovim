#!/usr/bin/env bash

## Configuration management functions

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "${THIS_DIR}/path.sh"

###############################
# Config Management Functions #
###############################

function symlink-config() {
    ## Create symbolic link from repository's config/nvim path to ~/.config/nvim
    #  Usage: symlink-config "config1" "config2" ...
    
    local -n REPO_CONFIGS=$1
    
    if [[ ${#REPO_CONFIGS[@]} -eq 0 ]]; then
      echo "[ERROR] Did not find any neovim configurations at path: ${CWD}/config"
      return 1
    fi

    ## Symlink discovered configurations
    for conf in "${REPO_CONFIGS[@]}"; do
        ## Get absolute path to config file
        abs_path=$(cd "${CWD}/config/$conf" && pwd)
        
        if [[ $DEBUG -eq 1 ]]; then
            echo "[DEBUG] Config absolute path: $abs_path"
        fi

        ## Check if directory exists
        if [[ -d "$DOTCONFIG_DIR/$conf" ]]; then
            echo "Neovim config already exists at $DOTCONFIG_DIR/$conf"
            continue
        elif [ -L "$DOTCONFIG_DIR/$conf" ]; then
            echo "Path is already a symlink: $DOTCONFIG_DIR/$conf"
            continue
        else

            echo "Creating symlink: $abs_path --> $DOTCONFIG_DIR/$conf"
            
            ## Create symlink
            ln -s "${abs_path}" "$DOTCONFIG_DIR/$conf"
            if [[ ! $? -eq 0 ]]; then
            echo "[ERROR] Could not create symlink for config: $conf to path: $DOTCONFIG_DIR/$conf"
            continue
            fi
        fi
    done
}

function detect_repo_configs() {
    ## Iterate over config directory & load discovered config dirs into NVIM_CONFIGS
    local NVIM_CONFIGS=()
    
    echo "Getting configurations from path: ${CWD}/config/" >&2

    for _conf in "${CWD}"/config/*; do
    if [ -d "$_conf" ]; then
        if [[ $DEBUG -eq 1 ]]; then
            echo "[DEBUG] Adding config: $_conf" >&2
        fi
        NVIM_CONFIGS+=("${_conf##*/}")
    fi
    done

    ## Return the array. Assign like: $NVIM_CONFIGS=($(detect_repo_configs))
    echo "${NVIM_CONFIGS[@]}"
}
