FROM steamcmd/steamcmd AS steambuild
MAINTAINER Ryan Smith <fragsoc@yusu.org>
MAINTAINER Laura Demkowicz-Duffy <fragsoc@yusu.org>

ARG APPID=423410
ARG UID=999

ENV CONFIG_LOC="/config"
ENV INSTALL_LOC="/blackwake"
ENV HOME=$INSTALL_LOC

# Upgrade the system
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends --assume-yes wine-stable wine32 xvfb

# Install the blackwake server
RUN mkdir -p $INSTALL_LOC
RUN steamcmd \
    +login anonymous \
    +force_install_dir $INSTALL_LOC \
    +app_update $APPID validate \
    +quit

# Setup directory structure and permissions
RUN useradd -m -s /bin/false -u $UID blackwake && \
    mkdir -p $CONFIG_LOC $INSTALL_LOC && \
    ln -s $CONFIG_LOC/Server.cfg $INSTALL_LOC/Server.cfg && \
    ln -s $CONFIG_LOC/bans.txt $INSTALL_LOC/bans.txt && \
    chown -R blackwake:blackwake $INSTALL_LOC $CONFIG_LOC

# I/O
VOLUME $CONFIG_LOC
EXPOSE 25001/udp 26915/udp 27015/udp

# Expose and run
USER blackwake
WORKDIR $INSTALL_LOC
ENTRYPOINT ["xvfb-run", "wine", "./BlackwakeServer.exe", "-batchmode", "-nographics"]
