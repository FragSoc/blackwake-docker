ARG BASE_IMAGE=fragsoc/steamcmd-wine-xvfb
FROM rustagainshell/rash:1.7.0 AS rash
FROM ${BASE_IMAGE} AS steambuild
MAINTAINER Ryan Smith <fragsoc@yusu.org>
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

USER root

ENV INSTALL_LOC="/blackwake"
ENV HOME=$INSTALL_LOC

WORKDIR /

# Setup directory structure and permissions
ARG UID=999
ARG GID=999
RUN groupadd -g $GID blackwake && \
    useradd -m -s /bin/false -u $UID -g blackwake blackwake && \
    mkdir -p $INSTALL_LOC && \
    chown -R blackwake:blackwake $INSTALL_LOC

USER blackwake

# Install the blackwake server
ARG APPID=423410
ARG STEAM_BETA
RUN steamcmd \
        +force_install_dir $INSTALL_LOC \
        +login anonymous \
        +@sSteamCmdForcePlatformType windows \
        +app_update $APPID $STEAM_BETA validate \
        # Steam libraries
        +app_update 1007 validate \
        +quit

COPY --from=rash /bin/rash /usr/bin/rash
COPY docker-entrypoint.rh /docker-entrypoint.rh
COPY Server.cfg.j2 /Server.cfg

# I/O
EXPOSE 25001/udp 27015/udp

# Expose and run
WORKDIR $INSTALL_LOC
ENTRYPOINT ["/usr/bin/rash", "/docker-entrypoint.rh"]
