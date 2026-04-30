#!/usr/bin/env bash

## Configuration management functions

__NEOVIM_CONFIG_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "${__NEOVIM_CONFIG_LIB_DIR}/path.sh"
unset __NEOVIM_CONFIG_LIB_DIR

###############################
# Config Management Functions #
###############################

function symlink-config() {
    ## Create symbolic link from repository's config/nvim path to ~/.config/nvim
    #  Usage: symlink-config "config1" "config2" ...
    
        local -n repo_configs_ref=$1
    
        if [[ ${#repo_configs_ref[@]} -eq 0 ]]; then
      echo "[ERROR] Did not find any neovim configurations at path: ${CWD}/config"
      return 1
    fi

    ## Symlink discovered configurations
        for conf in "${repo_configs_ref[@]}"; do
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

#########################
# Profile Data Cleanup  #
#########################

function discover_profile_names() {
    ## Discover valid profile names from repo config directory
    ## Usage: discover_profile_names "/path/to/config" OUT_ARRAY_NAME
    local config_dir="$1"
    local -n out_profiles=$2

    out_profiles=()

    if [[ ! -d "$config_dir" ]]; then
        return 1
    fi

    for d in "$config_dir"/*/; do
        [[ -d "$d" ]] && out_profiles+=("$(basename "$d")")
    done

    [[ ${#out_profiles[@]} -gt 0 ]]
}

function profile_is_valid() {
    ## Check if a profile exists in a discovered profile list
    ## Usage: profile_is_valid "nvim" PROFILES_ARRAY_NAME
    local profile="$1"
    local -n profiles=$2
    local p

    for p in "${profiles[@]}"; do
        if [[ "$p" == "$profile" ]]; then
            return 0
        fi
    done

    return 1
}

function profile_data_cleanup_targets() {
    ## Build data-only cleanup targets for a profile under ~/.local/share
    ## Usage: profile_data_cleanup_targets "profile" OUT_ARRAY_NAME
    local profile="$1"
    local -n out_targets=$2
    local data_dir="$HOME/.local/share/${profile}"

    out_targets=("$data_dir")

    ## nvim12 keeps vim.pack under its data dir; ensure it is cleaned too
    if [[ "$profile" == "nvim12" ]]; then
        out_targets+=("$data_dir/vim.pack")
    fi
}

function remove_targets_with_prompt() {
    ## Remove cleanup targets with optional confirmation
    ## Usage: remove_targets_with_prompt TARGET_ARRAY_NAME AUTO_YES
    local -n targets=$1
    local auto_yes=$2
    local dir
    local ans

    for dir in "${targets[@]}"; do
        if [[ ! -e "$dir" ]]; then
            echo "Skipping: $dir does not exist."
            continue
        fi

        if [[ "$auto_yes" -eq 0 ]]; then
            read -rp "About to remove data path '$dir'. Continue? [y/N] " ans
            case "$ans" in
                [Yy]*) ;;
                *)
                    echo "Skipped $dir"
                    continue
                    ;;
            esac
        fi

        echo "Removing $dir ..."

        if rm -rf -- "$dir" 2>/dev/null; then
            echo "Removed $dir"
            continue
        fi

        if sudo rm -rf -- "$dir"; then
            echo "Removed $dir"
        else
            echo "Failed to remove $dir" >&2
        fi
    done
}
