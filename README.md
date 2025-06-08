# Containerized Starbound Dedicated Server
This is a Starbound Dedicated Server that runs in a Docker Container

# Key Features
- Works with Steam Guard
- Supports automatically downloading mods from the Steam Workshop
- Automatically updates the server and the mods each time the Container starts

# Persisting the Starbound Universe across container restarts
The following 2 directories are available to be mounted


Except for simple testing you will want to persist your Starbound Universe. 
Since no data in a Docker Container is persisted you will need to mount the directory /steam/starbound to a directory outside of the Container


# TODO : FINISH EDITING THIS

Talk about mounting using:  
docker run -v <host_path>:<container_path> <image_name>
add instructions for mounting via QNap QTS also

SEE TODO.md file and the Modifications from original source files.md files

https://github.com/PeteCIS/containerized-starbound-dedicated-server/blob/Peter-in-progress/TODOs
https://github.com/PeteCIS/containerized-starbound-dedicated-server/blob/Peter-in-progress/Modifications%20from%20original%20source%20files.md


Talk about opening ports 21025 and 21026 (Rcon)
Investigate adding both ports as env variables
investigate setting both ports to be the defaults. Right now they're set to 28015 and 28016 which are default ports for a different game (probably Rust).
Move some of these notes into the TODO.md file instead of here



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
See the [Environment Variables](#environment-varibales) section

# Attributions
A lot of credit goes to:
- Didstopia over at: https://github.com/Didstopia/starbound-server
  - Containerization strategy with error handling logic that works with SteamGuard

- AzureOwl over at https://github.com/Azure-Owl/starbound-server
   - Steam workshop Mod support
