#!/usr/bin/env bash

## Utility functions and platform detection

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "${THIS_DIR}/path.sh"

#####################
# Utility Functions #
#####################

function exit_with_error() {
    ## When the script errors, exit preemptively and cleanup the build directory
    echo "[ERROR] Exiting prematurely, doing script cleanup."

    exit 1
}

function eval_last() {
    ## Evaluate the last exit code
    if [[ $1 -eq 0 ]]; then
        return
    elif [[ $1 -eq 1 ]]; then
        echo "Non-zero exit code on the last command. Exiting."

        exit 1
    fi
}

######################
# Platform Detection #
######################

## Determine OS release and family
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_RELEASE=$NAME
    OS_VERSION=${VERSION_ID:-"Unknown"}
    OS_FAMILY="Unknown"

    ## Check for ID_LIKE or use ID as a fallback
    if [ -n "$ID_LIKE" ]; then
        if echo "$ID_LIKE" | grep -q "debian"; then
            OS_FAMILY="Debian-family"
        elif echo "$ID_LIKE" | grep -q "rhel"; then
            OS_FAMILY="RedHat-family"
        fi
    elif [ -n "$ID" ]; then
        if echo "$ID" | grep -qE "debian|ubuntu"; then
            OS_FAMILY="Debian-family"
        elif echo "$ID" | grep -qE "rhel|fedora|centos"; then
            OS_FAMILY="RedHat-family"
        fi
    fi
else
    OS_RELEASE="Unknown"
    OS_VERSION="Unknown"
    OS_FAMILY="Unknown"
fi

## Determine the CPU architecture
CPU_ARCH=$(uname -m)

## Determine the OS type
OS_TYPE=$(uname -s)

## Detect container environment
#  Set CONTAINER_ENV=1 to enable
CONTAINER_ENV=${CONTAINER_ENV:-0}

## Export the variables
export OS_TYPE OS_RELEASE OS_FAMILY CPU_ARCH

## Set PKG_MGR var
if [[ $OS_FAMILY == "RedHat-family" ]]; then
    if [[ $DEBUG -eq 1 ]]; then
        echo "[DEBUG] RedHat-family OS detected."
    fi

    if ! command -v dnf >/dev/null 2>&1; then
        echo "dnf not detected. Trying yum"

        if ! command -v yum 2 >/dev/null &>1; then
            echo "[ERROR] RedHat family OS was detected, but script could not find dnf or yum package manager..."

            exit 1
        else
            PKG_MGR="yum"
        fi
    else
        PKG_MGR="dnf"
    fi
elif [[ $OS_FAMILY == "Debian-family" ]]; then
    if [[ $DEBUG -eq 1 ]]; then
        echo "[DEBUG] Debian-family OS detected."
    fi

    if [[ $CONTAINER_ENV -eq 1 || $CONTAINER_ENV == "1" ]]; then
        echo "Script detected a container environment. Fallback to apt-get"
        PKG_MGR="apt-get"
    else
        PKG_MGR="apt"
    fi
else
    echo "[WARNING] Platform not supported: [ OS Family: $OS_FAMILY, Release: $OS_RELEASE, Version: $OS_VERSION ]"
    exit 1
fi

## Check if host platform is an LXC container
if grep -q 'container=lxc' /proc/1/environ 2>/dev/null; then
    IS_LXC="true"
else
    IS_LXC="false"
fi

## Create a print-able platform string
PLATFORM_STR="\n
\t[ Platform Info ]\n
\tCPU: ${CPU_ARCH}\n
\tOS Family: ${OS_FAMILY}\n
\tRelease: ${OS_RELEASE}\n
\tRelease Version: ${OS_VERSION}\n
\tPackage Manager: ${PKG_MGR}\n
\tLXC container: ${IS_LXC}\n
"

######################
# Platform Functions #
######################

function print_platform() {
    echo -e $PLATFORM_STR
}

function print_unsupported_platform() {
    echo "[WARNING] Platform not supported: [ OS Family: $OS_FAMILY, Release: $OS_RELEASE, Version: $OS_VERSION ]"
}

############################
# System Dependency Checks #
############################

function check_system_dependencies() {
    ## Check if curl is installed
    if ! command -v curl > /dev/null 2>&1; then
        echo "[WARNING] curl is not installed."

        if [[ $PKG_MGR == "dnf" ]]; then
            sudo dnf install -y curl
        elif [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
            sudo $PKG_MGR install -y curl
        else
            print_unsupported_platform
            exit 1
        fi
    fi

    ## Check if unzip is installed
    if ! command -v unzip > /dev/null 2>&1; then
        echo "[WARNING] unzip is not installed."

        if [[ $PKG_MGR == "dnf" ]]; then
            sudo dnf install -y unzip
        elif [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
            sudo $PKG_MGR install -y unzip
        else
            print_unsupported_platform
            exit 1
        fi
    fi

    ## Check if fontconfig is installed
    if ! command -v fc-cache > /dev/null 2>&1; then
        echo "[WARNING] fontconfig is not installed."

        if [[ $PKG_MGR == "dnf" ]]; then
            sudo dnf install -y fontconfig
        elif [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
            sudo $PKG_MGR install -y fontconfig
        else
            print_unsupported_platform
            exit 1
        fi
    fi
}

function pkg_mgr_update() {
    if [[ $PKG_MGR == "apt" || $PKG_MGR == "apt-get" ]]; then
        echo "Updating packages with $PKG_MGR"
        sudo $PKG_MGR update -y
    elif [[ $PKG_MGR == "dnf" || $PKG_MGR == "yum" ]]; then
        echo "Updating packages with $PKG_MGR"
        sudo $PKG_MGR update -y
    fi
}
