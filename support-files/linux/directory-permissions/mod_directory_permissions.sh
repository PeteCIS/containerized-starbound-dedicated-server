#!/bin/bash

# mod_directory_permissions.sh
# Recursively modify directory permissions for a given group
# Reads paths, group, and permissions from (in order of precedence):
# 1. Command line arguments
# 2. Environment variables
# 3. Files (paths.txt, group.txt, permissions.txt)

##############################
# Usage Function
##############################
print_usage() {
    cat <<EOF
Usage: $0 [--paths "path1,path2,..."] [--group GROUP] [--permissions "+read,-write,+execute"]
Options:
  --paths         Comma-separated list of directory paths to process.
  --group         Linux group name to assign to the directories.
  --permissions   Comma-separated list of permissions to add/remove. Each permission is "+read", "-write", or "+execute", etc.
  --help          Show this usage information.

Input precedence: Command line > Environment variables > Files (paths.txt, group.txt, permissions.txt)

See How-To-Use.md for detailed instructions and examples.
EOF
}

##############################
# Functions for messaging
##############################

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
    print_usage
}

##############################
# Parse Inputs
##############################

# Helper: Convert permission words to chmod symbols
# $1: permission word ("read", "write", "execute")
perm_to_symbol() {
    case "$1" in
        read) echo "r" ;;
        write) echo "w" ;;
        execute) echo "x" ;;
        *)
            log_error "Unknown permission: $1"
            exit 1
            ;;
    esac
}

# 1. Parse command line arguments
CMD_PATHS=""
CMD_GROUP=""
CMD_PERMISSIONS=""
if [[ "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --paths)
            CMD_PATHS="$2"
            shift 2
            ;;
        --group)
            CMD_GROUP="$2"
            shift 2
            ;;
        --permissions)
            CMD_PERMISSIONS="$2"
            shift 2
            ;;
        --help)
            print_usage
            exit 0
            ;;
        *)
            log_error "Unknown argument: $1"
            exit 1
            ;;
    esac
done

##############################
# Read Input Sources
##############################

# Highest precedence: command line
if [[ -n "$CMD_PATHS" && -n "$CMD_GROUP" && -n "$CMD_PERMISSIONS" ]]; then
    log_info "Using command line arguments."
    IFS=',' read -r -a PATHS <<< "$CMD_PATHS"
    GROUP="$CMD_GROUP"
    IFS=',' read -r -a PERMISSIONS <<< "$CMD_PERMISSIONS"
# Second precedence: environment variables
elif [[ -n "$MDP_PATHS" && -n "$MDP_GROUP" && -n "$MDP_PERMISSIONS" ]]; then
    log_info "Using environment variables."
    IFS=',' read -r -a PATHS <<< "$MDP_PATHS"
    GROUP="$MDP_GROUP"
    IFS=',' read -r -a PERMISSIONS <<< "$MDP_PERMISSIONS"
# Lowest precedence: files
else
    log_info "Reading paths, group, and permissions from files."

    if [[ ! -f "paths.txt" ]]; then
        log_error "paths.txt not found."
        exit 1
    fi
    if [[ ! -f "group.txt" ]]; then
        log_error "group.txt not found."
        exit 1
    fi
    if [[ ! -f "permissions.txt" ]]; then
        log_error "permissions.txt not found."
        exit 1
    fi

    # Read paths (can be one or more, ignore empty lines)
    mapfile -t PATHS < <(grep -v '^\s*$' paths.txt)
    # Read group (first non-empty line)
    GROUP=$(grep -v '^\s*$' group.txt | head -n 1)
    # Read permissions (can be multiple)
    mapfile -t PERMISSIONS < <(grep -v '^\s*$' permissions.txt)
fi

##############################
# Validation
##############################

if [[ ${#PATHS[@]} -eq 0 ]]; then
    log_error "No directory paths specified."
    exit 1
fi

if [[ -z "$GROUP" ]]; then
    log_error "No group specified."
    exit 1
fi

if [[ ${#PERMISSIONS[@]} -eq 0 ]]; then
    log_error "No permissions specified."
    exit 1
fi

##############################
# Process Permissions
##############################

# Compose chmod symbolic string for group based on permissions
# Supports multiple + and - operations (e.g., +r -w)

CHMOD_ADD=""
CHMOD_REMOVE=""

for perm in "${PERMISSIONS[@]}"; do
    sign="${perm:0:1}"
    word="${perm:1}"
    symbol=$(perm_to_symbol "$word")
    if [[ "$sign" == "+" ]]; then
        CHMOD_ADD+="$symbol"
    elif [[ "$sign" == "-" ]]; then
        CHMOD_REMOVE+="$symbol"
    else
        log_error "Invalid permission format: $perm"
        exit 1
    fi
done

##############################
# Apply Permissions
##############################

for DIR in "${PATHS[@]}"; do
    log_info "Processing directory: $DIR"

    # Check if directory exists
    if [[ ! -d "$DIR" ]]; then
        log_error "Directory not found: $DIR"
        continue
    fi

    # Change group ownership recursively
    log_info "Setting group ownership to '$GROUP' recursively for $DIR"
    chown -R :"$GROUP" "$DIR"

    # Set permissions recursively
    if [[ -n "$CHMOD_ADD" ]]; then
        log_info "Adding group permissions: $CHMOD_ADD recursively for $DIR"
        chmod -R "g+$CHMOD_ADD" "$DIR"
    fi
    if [[ -n "$CHMOD_REMOVE" ]]; then
        log_info "Removing group permissions: $CHMOD_REMOVE recursively for $DIR"
        chmod -R "g-$CHMOD_REMOVE" "$DIR"
    fi

    log_info "Completed processing $DIR"
done

log_info "All operations completed."
