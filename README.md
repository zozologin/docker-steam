base image with Steam
=====================

**steamcmd** ready to download and run stuff inside a container.

[![](https://images.microbadger.com/badges/image/wmark/steam-base.svg)](https://microbadger.com/images/wmark/steam-base "Get your own image badge on microbadger.com")

If `+login anonymous` works (see the examples below)
then you don't need to log in, leaving your personal credentials on the servers.

## Docker
You most probably want to use it like this on the console:

```bash
# Download the latest version of something, like a game server.
docker run -ti --rm \
  -v /var/lib/steam:/var/lib/steam \
  wmark/steam-base /opt/steam/steamcmd.sh \
    +login anonymous \
    +force_install_dir /var/lib/steam/ark-dedicated \
    +app_update 376030 validate \
    +quit

# This is how you can run something in this container, which derives from Ubuntu.

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

It is a good idea to store folder `/var/lib/steam` outside of any containers
to avoid repeated downloads, and to share the files across multiple game server instances.

## rkt

The default implied user and group is `--user=1000 --group=1000`.
If you want to install games using a different user or group, then adjust the target directory's ownership as well.

```bash
mkdir -p /var/lib/steam/logs
chown 1000:1000 /var/lib/steam
chattr +C /var/lib/steam       # optional

# I've used rkt version 1.19.0 here. Replace it with yours.

sudo rkt run --interactive \
  --volume gameserver,kind=host,source=/var/lib/steam \
  --volume logdir,kind=host,source=/var/lib/steam/logs \
  --stage1-name=coreos.com/rkt/stage1-fly:1.19.0 \
  blitznote.com/aci/steamcmd:1 \
    -- +login anonymous \
    +force_install_dir /var/lib/steam/csgo \
    +app_update 740 validate \
    +quit
```
