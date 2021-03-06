<div align="center">
    <a href="http://www.blackwake.com/"><img width=100% src="https://pcbuildsonabudget.com/wp-content/uploads/2017/03/blackwake-banner.jpg"/></a>
</div>

---

A [docker](https://www.docker.com/) image for running a dedicated server for the game [Blackwake](http://www.blackwake.com/).

## Quickstart

```bash
docker build -t fragsoc/blackwake https://github.com/FragSoc/blackwake-docker.git && \
    docker run -d -p 25001:25001/udp -p 27015:27015/udp fragsoc/blackwake
```

## Running

Ports `27015` and `25001` are required to be open on UDP.
These can be changed, see the below table.

There is one volume at `/config` that contains server configuration files such as banlists and admin lists.
Most configuration is handled with environment variables - if you need finer control, you can mount your own custom `Server.cfg` file at `/Server.cfg.j2`.

Environment Variable | Default Value | Description
---|---|---
`SERVER_NAME` | `A Dockerised Blackwake Server` | The server name to show in the master server list
`SERVER_PASSWORD` | | The password required to join the server
`DISCORD_LINK` | | The discord link shown in the master server list
`SERVER_PORT` | `25001` | The port the server will run on (UDP), make sure to forward this!
`STEAM_PORT` | `27015` | The port that steam integration will use (UDP), make sure to forward this if you want the server to appear in the master list and utilise other steam features!

## Building

Build Arg | Default Value | Description
---|---|---
`APPID` | `423410` | The steam app ID to download. Don't change this unless you know what you're doing.
`STEAM_BETA` | | The string passed to `steamcmd` to install beta versions of the game, eg. `-beta mybetaname -betapassword letmein`
`UID` | `999` | The *nix user ID of the user to run within the container
`GID` | `999` | The *nix group ID of the primary group of the user to run within the container

## Licensing

This repository is licensed under the [AGPL](https://www.gnu.org/licenses/agpl-3.0.en.html).

Blackwake itself is licensed by [Mastfire Studios](http://www.blackwake.com/), no credit is taken for the software running in this container.
