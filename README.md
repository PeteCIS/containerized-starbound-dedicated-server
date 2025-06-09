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

## OPTION 3: QNAP QTS Container Station
Container Staion has a UI to define volumes on the Host. You can then map the volumes exposed by the docker image to the volumes on the host during container creation.
- See "Advanced Settings->Storage" when creating a container

## Container Volumes That Are Exposed
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


# Environment Varibales
The following environment variables are available:
```
STEAM_USERNAME             DEFAULT: ""     - Required for installing/updating Starbound
STEAM_PASSWORD             DEFAULT: ""     - Required for installing/updating Starbound
SKIP_STEAMCMD              DEFAULT: ""     - Optional for skipping updating Starbound - also skips downloading the mods
MOD_IDS                    DEFAULT: ()     - List of mods to download from the Steam Workshop

PGID                       DEFAULT: 3000   - The group ID of the group that will run the starbound server
PUID                       DEFAULT: 3000   - The user ID of the user that will run the starbound server
ENABLE_PASSWORDLESS_SUDO   DEFAULT: false  - Mostly don't touch this unless you really need to.
```
NOTES:
- PGID and PUID are set to 3000 because many linux systems start making users with ID's at 1000. So, changed to 3000 to ensure uniqueness
- MOD_IDS: See the [Steam Worksho Mods](#steam-workshop-mods) section


# Steam Workshop Mods
In order to install mods, add the workshop ids to the MOD_IDS environment variable separated by a space.

Examples: 
- MOD_IDS=(729480149 753790671)
- MOD_IDS=(729427606 731213804 731772286 732358921 734714560 737349249)

## How To Find Mod ID's
To find a mod's ID on the Steam Workshop, you'll need to visit the mod's page on the Steam Community and look for it in the URL or by examining the mod's page settings. The mod ID is a unique number associated with the mod. 
Here's how to find it:
1. Go to the Steam Workshop and locate the mod:
    - Navigate to the Steam Workshop and find the specific mod you're interested in. 
2. Open the mod's page:
    - Click on the mod to open its detailed page. 
3. Find the ID in the URL:
    - The mod ID is typically part of the URL. It will look something like ?id=xxxxxxxxxx (replace xxxxxxxx with the actual number). 
4. If not in the URL, look for it in the mod's page settings:
    - Some mods may display their ID prominently on the mod's page, often in the "Details" or "Settings" section. 


# Port Forwarding
The following ports are exposed from the image and can be mapped to ports on the host
21025      Primary multiplayer networking port
21026      RCon Server port - Optional

NOTES: 
- Make sure to edit the starbound_server.config file to ensure it is set to use the same ports as what is defined for the container
- See prior section for location of the starbound_server.config file

# Steam Guard

##Container Configuration To Enable Wokring With Steam Guard Enabled
For a Steam account with Steam Guard enabled, you must configure the container with:
1. Interactive
  - `-i` (`stdin_open: true` in Compose)
2. TTY Allocated
  - `-t` (`tty: true` in Compose)

## How To Enter Steam Guard Code When Starting The Container
Upon starting up the container for the first time
- Be ready to attach to the container as soon as you launch it (You will need to quickly be able to provide the authentication code)
  - (eg. `docker attach starbound-server`, enter the auth code and detach by pressing `CTRL-p` followed by `CTRL-q`)
  - QNAP Container Station provides an attach option via the UI
- You should not have to enter another Steam Guard code for a while. It might eventually expire and require another code to be entered.


# Running The Starbound Server
The Starbound server will run automatically when the container starts.

# Installing / Updating The Starbound Server & Mods
The Starbound Server and mods will be automatically updated each time the container is started/restarted

Ensure you have "STEAM_USERNAME" and "STEAM_PASSWORD" set
Make sure to have your Steam username and password setup in the environment variables.
See the [Environment Variables](#environment-varibales) section.


# Configuring The Starbound Server
The server configuration file is located here:  "/steamcmd/starbound/storage/starbound_server.config"

# Starbound Universe Location
The Starbound Universe is the saved data for the starbound server. This includes all planets and everything built/changed on each planet
- NOTE: Your player saved data is stored on your local computer. Make sure to back that up regularly. Starbound does not use the steam cloud.
"/steamcmd/starbound/storage/universe"

# Starbound Mods
"/steamcmd/starbound/mods"


# Attributions
A lot of credit goes to:
- Didstopia over at: https://github.com/Didstopia/starbound-server and https://hub.docker.com/r/didstopia/starbound-server
  - Containerization strategy with error handling logic that works with SteamGuard

- AzureOwl over at https://github.com/Azure-Owl/starbound-server and https://hub.docker.com/r/azureowl/starbound-server
   - Steam workshop Mod support
 
# See Also
SEE "TODO.md" file and the "Modifications from original source files.md files.md"
TODO: Add links 
- [TODO List](TODOs.md)
- [Modifications of the Original Source Files](<Modifications from original source files.md>)


