#!/bin/bash

# mod_directory_permissions.sh
# This script modifies directory permissions for a specified Linux group.
# It supports three input methods, in order of precedence:
# 1. Command line arguments
# 2. Environment variables
# 3. Input files (paths.txt, group.txt, permissions.txt)

# -------------------------------
# Function to print usage
# -------------------------------
usage() {
    echo "Usage:"
    echo "  $0 -p <paths> -g <group> -m <permissions>"
    echo ""
    echo "  -p <paths>         : Comma-separated list of directory paths"
    echo "  -g <group>         : Linux group name"
    echo "  -m <permissions>   : Comma-separated permissions changes, e.g. '+read,-write,+execute'"
    echo ""
    echo "If arguments are not supplied, the script will check environment variables:"
    echo "  MDP_PATHS, MDP_GROUP, MDP_PERMISSIONS"
    echo ""
    echo "If environment variables are not set, the script will read from:"
    echo "  paths.txt, group.txt, permissions.txt"
    exit 1
}

# -------------------------------
# Function to map permission words to chmod symbols
# -------------------------------
perm_to_symbol() {
    case "$1" in
        read) echo "r" ;;
        write) echo "w" ;;
        execute) echo "x" ;;
        *) echo "" ;;
    esac
}

# -------------------------------
# Parse command line arguments if provided
# -------------------------------
CMD_PATHS=""
CMD_GROUP=""
CMD_PERMS=""
while getopts "p:g:m:h" opt; do
    case $opt in
        p) CMD_PATHS="$OPTARG" ;;
        g) CMD_GROUP="$OPTARG" ;;
        m) CMD_PERMS="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# -------------------------------
# Determine input source (precedence: CLI > ENV > FILES)
# -------------------------------
if [[ -n "$CMD_PATHS" || -n "$CMD_GROUP" || -n "$CMD_PERMS" ]]; then
    # Command line parameters detected
    echo "Using command line parameters."
    IFS=',' read -r -a DIR_PATHS <<< "$CMD_PATHS"
    GROUP="$CMD_GROUP"
    IFS=',' read -r -a PERMISSIONS <<< "$CMD_PERMS"
elif [[ -n "$MDP_PATHS" || -n "$MDP_GROUP" || -n "$MDP_PERMISSIONS" ]]; then
    # Environment variables detected
    echo "Using environment variables."
    IFS=',' read -r -a DIR_PATHS <<< "$MDP_PATHS"
    GROUP="$MDP_GROUP"
    IFS=',' read -r -a PERMISSIONS <<< "$MDP_PERMISSIONS"
else
    # Fallback to files
    echo "Using files: paths.txt, group.txt, permissions.txt"
    if [[ ! -f "paths.txt" || ! -f "group.txt" || ! -f "permissions.txt" ]]; then
        echo "Error: One or more input files (paths.txt, group.txt, permissions.txt) are missing."
        exit 1
    fi
    mapfile -t DIR_PATHS < paths.txt
    GROUP=$(head -n 1 group.txt)
    mapfile -t PERMISSIONS < permissions.txt
fi

# -------------------------------
# Validate inputs
# -------------------------------
if [[ -z "$GROUP" ]]; then
    echo "Error: Group must be specified."
    usage
fi

if [[ ${#DIR_PATHS[@]} -eq 0 ]]; then
    echo "Error: At least one directory path must be specified."
    usage
fi

if [[ ${#PERMISSIONS[@]} -eq 0 ]]; then
    echo "Error: At least one permission change must be specified."
    usage
fi

echo "Directories:"
for d in "${DIR_PATHS[@]}"; do
    echo "  $d"
done
echo "Group: $GROUP"
echo "Permissions:"
for p in "${PERMISSIONS[@]}"; do
    echo "  $p"
done

# -------------------------------
# Apply permissions
# -------------------------------
for dir in "${DIR_PATHS[@]}"; do
    echo "Processing directory: $dir"

    # Check if directory exists
    if [[ ! -d "$dir" ]]; then
        echo "  Skipping: Directory does not exist."
        continue
    fi

    # Change group ownership
    echo "  Setting group ownership to $GROUP"
    chgrp -R "$GROUP" "$dir"

    # Build chmod string for each permission
    for perm in "${PERMISSIONS[@]}"; do
        # Remove whitespace
        perm=$(echo "$perm" | xargs)
        sign="${perm:0:1}"
        perm_word="${perm:1}"
        perm_sym=$(perm_to_symbol "$perm_word")

        if [[ -z "$perm_sym" ]]; then
            echo "  Invalid permission: $perm"
            continue
        fi

        echo "  Applying permission: $sign$perm_word (g$sign$perm_sym)"
        chmod -R "g${sign}${perm_sym}" "$dir"
    done
done

echo "Done."
