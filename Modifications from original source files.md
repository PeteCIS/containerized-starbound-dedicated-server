This project started as a mixup of the didstopia and the AzuerOwl containers.
Since the initial concept a number of small changes were made. 
While it will be simple enough to diff the files with the original sources, this file endeavors to capture a high level record of the changes that were made

# Dockerfile changes

## Removed hard coded numbers for PGID and PUID
The fixing of permissions section code used a hard coded PGID and PUID of 1000. Moved the 2 environment variables above the fix permissions section and used them in that code
- OLD CODE:
  ```
  # Fix permissions
  RUN chown -R 1000:1000 \
      /steamcmd \
      /app
  
  # Run as a non-root user by default
  ENV PGID 1000
  ENV PUID 1000
  ```

- NEW CODE:
  ```
  # Run as a non-root user by default - used 3000 arbitrarily. UID's start at 1000 for new user accounts on many linux systems
  # Note: These values (as with any environment variabled) can be specified during container creation
  ENV PGID 3000
  ENV PUID 3000
  
  RUN chown -R ${PUID}:${PGID} \
      /steamcmd \
      /app
  ```


## NEED TO FIX THE /app.steam typo, should be /app/.steam

# start.sh changes

# install.txt changes

