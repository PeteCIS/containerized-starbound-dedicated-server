The base image I am using comes from here: https://github.com/Didstopia/docker-base-images
It seems to be working but possibly not suppported
Need to consider looking into moving to a supported ubuntu base image
This guys base image looks really nice though and he put a lot of thought into it. Just want to make sure my starbound server container will keep working
For example, Ubuntu 20.04 is the latest base image and it came out in April 2020. The most recent is 25.04.

This base image is provided with the MIT license so it should be ok for me to take a copy and update it to the latest. After success I should consider submitting a pull request with the changes I made



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
