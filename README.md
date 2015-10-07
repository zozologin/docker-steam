base image with Steam
=====================

[![](https://badge.imagelayers.io/wmark/steam-base:latest.svg)](https://imagelayers.io/?images=wmark/steam-base:latest 'image stats by imagelayers.io')

Please remember that
you don't need to provide your personal credentials to download a dedicated server
if "login anonymous" works!

You most probably want to use it like this on the console:

```bash
docker run -ti --rm \
  -v /var/lib/steam:/var/lib/steam \
  wmark/steam-base \
    /opt/steam/steamcmd.sh +login anonymous +force_install_dir /var/lib/steam/ark-dedicated +app_update 376030 validate +quit

# This list of ports is for ARK Survival.
# Your game will use different ports.
docker run -t --rm --name "my_ark" \
  -v /var/lib/steam:/var/lib/steam \
  -p 7777:7777/udp \
  -p 27015:27015/udp \
  -p 32330:32330 \
  wmark/steam-base \
    /var/lib/steam/ark-dedicated/ShooterGame/Binaries/Linux/ShooterGameServer \
    -server -log \
    TheIsland?listen?SessionName=no-name-server-clone?ServerAdminPassword=geheim
```

It is a good idea to store folder ```/var/lib/steam``` outside the Docker container.

