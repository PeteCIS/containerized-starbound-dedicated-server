#!/bin/bash

# mod_directory_permissions.sh
# Recursively modify directory permissions for a given group
# Reads settings (paths, group, and permissions) from (in order of precedence):
# 1. Command line arguments
# 2. Environment variables
# 3. A single settings file (settings.conf)

##############################
# Usage Function
##############################
print_usage() {
    cat <<EOF
Usage: $0 [--paths "path1,path2,..."] [--group GROUP] [--dir-permissions "+read,-write,+execute"] [--file-permissions "+read,-write,+execute"]
Options:
  --paths             Comma-separated list of directory paths to process.
  --group             Linux group name to assign to the directories and files.
  --dir-permissions   Comma-separated list of permissions for directories (e.g. "+read,+write,+execute").
  --file-permissions  Comma-separated list of permissions for files (e.g. "+read,-write").
  --settings-file     Path to a settings file (default: settings.conf).
  --help              Show this usage information.

Input precedence: Command line > Environment variables > File (settings.conf)

Environment Variables:
  MDP_PATHS             Comma-separated list of directory paths.
  MDP_GROUP             Linux group name.
  MDP_DIR_PERMISSIONS   Comma-separated directory permissions.
  MDP_FILE_PERMISSIONS  Comma-separated file permissions.

Settings File (default: settings.conf):
  The file should be in KEY=VALUE format, e.g.:
      PATHS=/foo/bar,/baz/qux
      GROUP=mygroup
      DIR_PERMISSIONS=+read,+write,+execute
      FILE_PERMISSIONS=+read,-write

  Only PATHS and GROUP are required.
  If no permissions are specified, only group ownership is set.

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

CMD_PATHS=""
CMD_GROUP=""
CMD_DIR_PERMISSIONS=""
CMD_FILE_PERMISSIONS=""
SETTINGS_FILE="settings.conf"

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
        --dir-permissions)
            CMD_DIR_PERMISSIONS="$2"
            shift 2
            ;;
        --file-permissions)
            CMD_FILE_PERMISSIONS="$2"
            shift 2
            ;;
        --settings-file)
            SETTINGS_FILE="$2"
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

if [[ -n "$CMD_PATHS" && -n "$CMD_GROUP" ]]; then
    log_info "Using command line arguments."
    IFS=',' read -r -a PATHS <<< "$CMD_PATHS"
    GROUP="$CMD_GROUP"
    if [[ -n "$CMD_DIR_PERMISSIONS" ]]; then
        IFS=',' read -r -a DIR_PERMISSIONS <<< "$CMD_DIR_PERMISSIONS"
    fi
    if [[ -n "$CMD_FILE_PERMISSIONS" ]]; then
        IFS=',' read -r -a FILE_PERMISSIONS <<< "$CMD_FILE_PERMISSIONS"
    fi
elif [[ -n "$MDP_PATHS" && -n "$MDP_GROUP" ]]; then
    log_info "Using environment variables."
    IFS=',' read -r -a PATHS <<< "$MDP_PATHS"
    GROUP="$MDP_GROUP"
    if [[ -n "$MDP_DIR_PERMISSIONS" ]]; then
        IFS=',' read -r -a DIR_PERMISSIONS <<< "$MDP_DIR_PERMISSIONS"
    fi
    if [[ -n "$MDP_FILE_PERMISSIONS" ]]; then
        IFS=',' read -r -a FILE_PERMISSIONS <<< "$MDP_FILE_PERMISSIONS"
    fi
else
    # Read settings from a single settings file
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        log_error "Settings file not found: $SETTINGS_FILE"
        exit 1
    fi
    log_info "Reading paths, group, and permissions from $SETTINGS_FILE."
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        key="$(echo "$key" | tr -d '[:space:]')"
        value="$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
        case "$key" in
            PATHS)
                IFS=',' read -r -a PATHS <<< "$value"
                ;;
            GROUP)
                GROUP="$value"
                ;;
            DIR_PERMISSIONS)
                IFS=',' read -r -a DIR_PERMISSIONS <<< "$value"
                ;;
            FILE_PERMISSIONS)
                IFS=',' read -r -a FILE_PERMISSIONS <<< "$value"
                ;;
            ""|\#*)
                # ignore empty lines and comments
                ;;
            *)
                log_info "Unknown key in settings file: $key"
                ;;
        esac
    done < "$SETTINGS_FILE"
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

if ! getent group "$GROUP" > /dev/null; then
    log_error "The specified group '$GROUP' does not exist."
    exit 1
fi

##############################
# Process Permissions
##############################

build_chmod_string() {
    local permissions=("$@")
    local add=""
    local remove=""
    for perm in "${permissions[@]}"; do
        sign="${perm:0:1}"
        word="${perm:1}"
        symbol=$(perm_to_symbol "$word")
        if [[ "$sign" == "+" ]]; then
            add+="$symbol"
        elif [[ "$sign" == "-" ]]; then
            remove+="$symbol"
        else
            log_error "Invalid permission format: $perm"
            exit 1
        fi
    done
    echo "$add|$remove"
}

DIR_CHMOD_ADD=""
DIR_CHMOD_REMOVE=""
FILE_CHMOD_ADD=""
FILE_CHMOD_REMOVE=""

if [[ ${#DIR_PERMISSIONS[@]} -gt 0 ]]; then
    perms_str=$(build_chmod_string "${DIR_PERMISSIONS[@]}")
    DIR_CHMOD_ADD="${perms_str%%|*}"
    DIR_CHMOD_REMOVE="${perms_str##*|}"
fi

if [[ ${#FILE_PERMISSIONS[@]} -gt 0 ]]; then
    perms_str=$(build_chmod_string "${FILE_PERMISSIONS[@]}")
    FILE_CHMOD_ADD="${perms_str%%|*}"
    FILE_CHMOD_REMOVE="${perms_str##*|}"
fi

##############################
# Apply Permissions (Manual Traversal)
##############################

process_path() {
    local path="$1"
    local group="$2"
    local is_dir="$3"
    local dir_add="$4"
    local dir_remove="$5"
    local file_add="$6"
    local file_remove="$7"

    log_info "Setting group ownership to '$group' for $path"
    chown :"$group" "$path"

    if [[ "$is_dir" == "1" ]]; then
        if [[ -n "$dir_add" ]]; then
            log_info "Adding group permissions: $dir_add to directory $path"
            chmod "g+$dir_add" "$path"
        fi
        if [[ -n "$dir_remove" ]]; then
            log_info "Removing group permissions: $dir_remove from directory $path"
            chmod "g-$dir_remove" "$path"
        fi
    else
        if [[ -n "$file_add" ]]; then
            log_info "Adding group permissions: $file_add to file $path"
            chmod "g+$file_add" "$path"
        fi
        if [[ -n "$file_remove" ]]; then
            log_info "Removing group permissions: $file_remove from file $path"
            chmod "g-$file_remove" "$path"
        fi
    fi
}

traverse_and_apply() {
    local dir="$1"
    local group="$2"
    local dir_add="$3"
    local dir_remove="$4"
    local file_add="$5"
    local file_remove="$6"

    process_path "$dir" "$group" 1 "$dir_add" "$dir_remove" "$file_add" "$file_remove"

    while IFS= read -r -d '' entry; do
        if [[ -d "$entry" ]]; then
            process_path "$entry" "$group" 1 "$dir_add" "$dir_remove" "$file_add" "$file_remove"
        elif [[ -f "$entry" ]]; then
            process_path "$entry" "$group" 0 "$dir_add" "$dir_remove" "$file_add" "$file_remove"
        fi
    done < <(find "$dir" -mindepth 1 ! -type l -print0)
}

for DIR in "${PATHS[@]}"; do
    log_info "Processing directory: $DIR"
    if [[ ! -d "$DIR" ]]; then
        log_error "Directory not found: $DIR"
        continue
    fi

    traverse_and_apply "$DIR" "$GROUP" "$DIR_CHMOD_ADD" "$DIR_CHMOD_REMOVE" "$FILE_CHMOD_ADD" "$FILE_CHMOD_REMOVE"

    log_info "Completed processing $DIR"

    # --- BEGIN: Prior approach using chmod -R (commented out) ---
    # The following block was previously used to modify permissions recursively.
    # This approach is commented out in favor of explicit directory traversal above.
    #
    # # Change group ownership recursively
    # log_info "Setting group ownership to '$GROUP' recursively for $DIR"
    # chown -R :"$GROUP" "$DIR"
    #
    # # Set permissions recursively
    # if [[ -n "$CHMOD_ADD" ]]; then
    #     log_info "Adding group permissions: $CHMOD_ADD recursively for $DIR"
    #     chmod -R "g+$CHMOD_ADD" "$DIR"
    # fi
    # if [[ -n "$CHMOD_REMOVE" ]]; then
    #     log_info "Removing group permissions: $CHMOD_REMOVE recursively for $DIR"
    #     chmod -R "g-$CHMOD_REMOVE" "$DIR"
    # fi
    # --- END: Prior approach using chmod -R (commented out) ---

done

log_info "All operations completed."
