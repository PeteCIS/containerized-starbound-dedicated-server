# Containerized Starbound Dedicated Server
This is a Starbound Dedicated Server that runs in a Docker Container

# Key Features
- Works with Steam Guard
  - See the [Steam Guard](#steam-guard) section for details
- Supports automatically downloading mods from the Steam Workshop
- Automatically updates the server and the mods each time the Container starts

# Persisting The Starbound Universe And Other Data Across Container Restarts
Unless you map these directories to a location outside of the container, no data will be saved after the container is restarted
Various options are listed below. 
- NOTE: Select only 1 of the options.

## OPTION 1: Mapping An Exposed Docker Container Volume To A Host Directory
One method of mapping the exposed Docker container volumes is to use the -v or --mount flag with the "docker run" command:
  ```
    docker run -v <host_path>:<container_path> <image_name>
  ```

## OPTION 2: Using Volumes To Map An Exposed Docker Container To A Host Directory
Another method of mapping the exposed Docker container volumes is to use docker volumes and create a volume on the host for each of the volumes exposed from the container

## OPTION 3: QNap QTS Container Station
Container Staion has a UI to define volumes on the Host. You can then map the volumes exposed by the docker image to the volumes on the host during container creation.
- See "Advanced Settings->Storage" when creating a container

## Container volumes which are exposed
The following 2 directories are available to be mounted
- /steamcmd/starbound
- /app/.steam

### /steamcmd/starbound
Important directories of note within this directory:
- storage
  - Contains the starbound_server.config file
  - Contains the universe directory that holds all the game save files
    
    - Except for simple testing you will want to persist your Starbound Universe.
    - NOTE: Your player saved data is stored on your local computer. Make sure to back that up regularly. Starbound does not use the steam cloud.


### /app/.steam
This is mostly optional. One of the uses of mapping this volume to a host directory is to access the steamcmd log files.
Some sub-directories of note are:
- /app/.steam/logs For the log files
- /app/.steam/userdata
- /app/.steam/config According to a google AI search the config.vdf file in this directory containes the cached credentials






# TODO : FINISH EDITING THIS




**NOTE**: This image will install/update on startup. The path ```/steamcmd/starbound``` can be mounted on the host for data persistence.

# How to run the server
1. Set the environment variables you wish to modify from below (note the Steam credentials)
2. Optionally mount ```/steamcmd/starbound``` somewhere on the host or inside another container to keep your data safe
3. Enjoy!

Be sure to edit `/steamcmd/starbound/storage/starbound_server.config` to customize your server's settings.  
Save files can be found under `/steamcmd/starbound/storage/universe` and mods under `/steamcmd/starbound/mods`.

Note that you can also mount `/app/.steam` to persist logs etc. from `steamcmd`.

# Environment Varibales

The following environment variables are available:
```
STEAM_USERNAME (DEFAULT: "" - Required for installing/updating Starbound)
STEAM_PASSWORD (DEFAULT: "" - Required for installing/updating Starbound)
SKIP_STEAMCMD  (DEFAULT: "" - Optional for skipping updating Starbound)
```

# Steam Guard

For a Steam account with SteamGuard

1. Run the container with both `-i` (`stdin_open: true` in Compose) and `-t` (`tty: true` in Compose) arguments, which effectively allows for direct interaction
2. Be ready to attach to the container as soon as you launch it, as you will need to relatively quickly be able to provide the authentication code (eg. `docker attach starbound-server`, enter the auth code and detach by pressing `CTRL-p` followed by `CTRL-q`)
3. This should now keep you logged in, at least until the authentication token expires, at which point you can simply do these steps again

NOTE: At some point we may make a less tedious workaround for this, such as a web interface which can be used to securely manage the Steam session, credentials and Steam Guard authentication codes.

# Updating the server
The server will update each time the container starts up.

Make sure to have your Steam username and password setup in the environment variables.
As long as you have both your `STEAM_USERNAME` and `STEAM_PASSWORD` set, simply restarting the container should trigger the update procedure.
See the [Environment Variables](#environment-varibales) section.

# Attributions
A lot of credit goes to:
- Didstopia over at: https://github.com/Didstopia/starbound-server
  - Containerization strategy with error handling logic that works with SteamGuard

- AzureOwl over at https://github.com/Azure-Owl/starbound-server
   - Steam workshop Mod support
 
# See Also
SEE "TODO.md" file and the "Modifications from original source files.md files.md"
TODO: Add links 
- [TODO List](TODOs.md)
- [Modifications of the Original Source Files]("Modifications from original source files.md")

