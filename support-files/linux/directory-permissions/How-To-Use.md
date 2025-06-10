# How To Use `mod_directory_permissions.sh`

This script recursively modifies directory and file group ownership and permissions for specified paths.  
You can configure its behavior using **command line arguments**, **environment variables**, or a single **settings file**.

---

## 1. Command Line Usage

```bash
./mod_directory_permissions.sh \
  --paths "/dir1,/dir2" \
  --group mygroup \
  --dir-permissions "+read,+write,+execute" \
  --file-permissions "+read,-write"
```

- `--paths` (required): Comma-separated list of directories to process.
- `--group` (required): Group to assign ownership to.
- `--dir-permissions` (optional): Comma-separated permissions for directories.
- `--file-permissions` (optional): Comma-separated permissions for files.
- `--settings-file` (optional): Path to a settings file (default: `settings.conf`).

**If no permissions are specified, only group ownership is set.**

---

## 2. Using Environment Variables

Set these variables before running the script:

```bash
export MDP_PATHS="/dir1,/dir2"
export MDP_GROUP="mygroup"
export MDP_DIR_PERMISSIONS="+read,+write,+execute"
export MDP_FILE_PERMISSIONS="+read,-write"
./mod_directory_permissions.sh
```

- Only `MDP_PATHS` and `MDP_GROUP` are required.
- If both command line arguments and environment variables are set, **command line takes precedence**.

---

## 3. Using a Settings File

The script supports a single settings file (default: `settings.conf`) with the following format:

```
PATHS=/dir1,/dir2
GROUP=mygroup
DIR_PERMISSIONS=+read,+write,+execute
FILE_PERMISSIONS=+read,-write
```

- Only `PATHS` and `GROUP` are required.
- Permissions are optional.
- You may specify a different file using the `--settings-file` option.

**Example:**

```bash
cat > settings.conf <<EOF
PATHS=/srv/shared,/srv/projects
GROUP=devteam
DIR_PERMISSIONS=+read,+write,+execute
FILE_PERMISSIONS=+read,-write
EOF

./mod_directory_permissions.sh
```

or with a custom file:

```bash
./mod_directory_permissions.sh --settings-file custom_settings.conf
```

---

## 4. Precedence Order

1. Command line arguments (highest)
2. Environment variables
3. Settings file (lowest)

---

## 5. Example: Change Only Group Ownership

```bash
./mod_directory_permissions.sh --paths "/data" --group mygroup
```
or
```bash
export MDP_PATHS="/data"
export MDP_GROUP="mygroup"
./mod_directory_permissions.sh
```
or
```
PATHS=/data
GROUP=mygroup
```
in `settings.conf`, then run:
```bash
./mod_directory_permissions.sh
```

---

## 6. Settings File Reference

- Lines starting with `#` are comments.
- Only the following keys are recognized:
    - `PATHS` (comma-separated string, required)
    - `GROUP` (string, required)
    - `DIR_PERMISSIONS` (comma-separated string, optional)
    - `FILE_PERMISSIONS` (comma-separated string, optional)

---

## 7. Help

```bash
./mod_directory_permissions.sh --help
```
Displays usage instructions, including details for environment variables and settings file.

---
