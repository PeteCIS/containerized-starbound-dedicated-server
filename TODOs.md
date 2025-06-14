This file contains a list of TODO's that I would like to accomplish for this project:

# Short Term
- Actually implement the changes listed in this file:
  - [Modifications of the Original Source Files](<Modifications from original source files.md>)
  - Right now it's a list of the stuff I definitely plan to do, but haven't actually done/tested yet.


# Medium Term
- Create a file with instructions on the steps to follow when creating a Starbound Server Container from QNAP Container Station

- Consider editing the dockerfile to expose another volume called "/shared_files"
  - This folder is used to share common files across multiple containers
  - Entirely optional, but helps if you want to get to a common set of files from the host (ex. common helper scripts)
  - Perhaps put this as an option inside the ubuntu base image instead





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

