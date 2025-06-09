This file contains a list of TODO's that I would like to accomplish for this project:













# Short Term
Talk about opening ports 21025 and 21026 (Rcon) BOTH need to be TCP, not UDP in the readme.md
Investigate adding both ports as env variables
investigate setting both ports to be the defaults. Right now they're set to 28015 and 28016 which are default ports for a different game (probably Rust).



# Medium Term







# Longer Term
Some items that I will get to after the first pass of the project is completed

## Update the base image of Ubuntu that is being used
- The base image I am using comes from here: https://github.com/Didstopia/docker-base-images.
- It seems to be working but possibly not suppported
- Need to consider looking into moving to a supported ubuntu base image
- Consider updating to a newer version of Ubuntu
  - This image uses Ubuntu 20.04 which came out in April 2020. The most recent is 25.04 from April 2025
- Didstopia's base image modifications look really nice. Looks like he put a lot of thought into it. But, I want to make sure my starbound server container will keep working long term
- This base image is provided with the MIT license so it should be ok for me to take a copy and update it to the latest. After success I should consider submitting a pull request with the changes I made

## Do we really need to mount the entire /app/.steam directory?
- Should we instead map to a few of the subdirectories separately?
  -  /app/.steam/logs        For the log files
  -  /app/.steam/userdata
  -  /app/.steam/config      According to a google AI search the config.vdf file in this directory containes the cached credentials
  - Is it worth the time to investigate this?

  - From a google AI search:
    "where are steamcmd login credentials cached on linux"
    
    On Linux, SteamCMD caches login credentials in the config/config.vdf file within the SteamCMD installation directory. 
    Specifically, the "ConnectCache" entry in this file stores the cached credentials. 
    If you need to clear or reset these credentials, you can remove the "ConnectCache" entry from this file. 
    SteamCMD will then prompt you for credentials again during the next login attempt. 


## Do we really need to mount the entire /steamcmd/starbound directory?
- Should we instead map to /steamcmd/starbound/storage directory?
- Are there any files required to be persisted aside from the storage directory?

