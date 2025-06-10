# How to Use `mod_directory_permissions.sh`

This script modifies directory permissions recursively for a specified Linux group, based on your input criteria.

## Usage

```
./mod_directory_permissions.sh [--paths "path1,path2,..."] [--group GROUP] [--permissions "+read,-write,+execute"] [--help]
```

### Options

- `--paths`         Comma-separated list of directory paths to process.
- `--group`         Linux group name to assign to the directories.
- `--permissions`   Comma-separated list of permissions. Each must be one of: `+read`, `-write`, `+execute`, etc.
- `--help`          Show usage information.

**Input precedence:**  
1. Command line arguments  
2. Environment variables  
3. Files (`paths.txt`, `group.txt`, `permissions.txt`)

---

## Examples

### 1. Using Command Line Arguments

```bash
./mod_directory_permissions.sh --paths "/srv/data,/srv/shared" --group "mygroup" --permissions "+read,-write,+execute"
```

### 2. Using Environment Variables

```bash
export MDP_PATHS="/srv/data,/srv/shared"
export MDP_GROUP="mygroup"
export MDP_PERMISSIONS="+read,-write,+execute"
./mod_directory_permissions.sh
```

### 3. Using Input Files

Create the following files in the same directory as the script:

- `paths.txt` (one directory per line):
    ```
    /srv/data
    /srv/shared
    ```
- `group.txt` (the group name on one line):
    ```
    mygroup
    ```
- `permissions.txt` (one permission per line, with `+` or `-`):
    ```
    +read
    -write
    +execute
    ```

Then run:

```bash
./mod_directory_permissions.sh
```

---

## Permission Words

Valid permissions are:
- `read`    → `r`
- `write`   → `w`
- `execute` → `x`

Prefix with `+` to add or `-` to remove the permission for the group.

Example:  
`+read` will add read permission for the group.  
`-write` will remove write permission for the group.

---

## Notes

- You must have the necessary permissions (e.g., run as root) to change group ownership and permissions on directories.
- The script prints clear messages for each step and prints usage information if you use `--help` or if there is an input error.
- For any input error, the specific error is shown, followed by the usage help.

---
