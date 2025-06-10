# Usage Examples for `mod_directory_permissions.sh`

 

## 1. Using Input Files

 

Prepare the following files in the script's directory:

 

**paths.txt**

```

/var/www/html

/home/shared/data

```

 

**group.txt**

```

developers

```

 

**permissions.txt**

```

+read

+write

-execute

```

 

Run the script:

```bash

./mod_directory_permissions.sh

```

 

---

 

## 2. Using Command Line Arguments (highest precedence)

 

```bash

./mod_directory_permissions.sh -p "/var/www/html,/home/shared/data" -g developers -m "+read,+write,-execute"

```

 

---

 

## 3. Using Environment Variables

 

```bash

export MDP_PATHS="/var/www/html,/home/shared/data"

export MDP_GROUP="developers"

export MDP_PERMISSIONS="+read,+write,-execute"

./mod_directory_permissions.sh

```

 

---

 

## Notes

 

- If command line arguments are provided, environment variables and files are ignored.

- If environment variables are set, files are ignored.

- If neither are set, the script reads from `paths.txt`, `group.txt`, and `permissions.txt`.

- The script outputs each step to standard output for transparency.
