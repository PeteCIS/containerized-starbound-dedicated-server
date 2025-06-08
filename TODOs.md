This file contains a list of TODO's that I would like to accomplish for this project:




Talk about opening ports 21025 and 21026 (Rcon) BOTH need to be TCP, not UDP
Investigate adding both ports as env variables
investigate setting both ports to be the defaults. Right now they're set to 28015 and 28016 which are default ports for a different game (probably Rust).



DO WE REALLY NEED TO MOUNT THE ENTIRE /app/.steam directory?? 
  - Should we instead map to /app/.steam/logs?
NOTES: Since this is not currently mapped properly it cannot be the source where the cached login credentials are stored
  example, it's currently mapped to /app.steam which is incorrect. Thus, this entire directory is not persisted across container restarts

DO WE REALLY NEED TO MOUNT THE ENTIRE /steamcmd/starbound directory?
  - Should we instead map to /steamcmd/starbound/storage directory?
- where are the steam cached credentials stored?


Investigate starbound query server and ports

# Short Term




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
