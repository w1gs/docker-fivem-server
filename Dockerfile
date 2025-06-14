FROM debian:bookworm-slim

RUN apt update && \
  apt upgrade -y && apt install -y --no-install-recommends xz-utils wget unzip screen nano openssh-server && \
  rm -rf /var/lib/apt/lists/*

RUN wget  --no-check-certificate -O /tmp/gotty.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz && \
  tar -C /usr/bin/ -xvf /tmp/gotty.tar.gz && \
  rm -rf /tmp/gotty.tar.gz

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_CONFIG=""
ENV SRV_ADR="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master"
ENV MANUAL_UPDATES=""
ENV ENABLE_WEBCONSOLE="true"
ENV GOTTY_PARAMS="-w --title-format FiveM"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV SERVER_KEY=""
ENV START_VARS=""
ENV DATA_PERM=770
ENV USER="fivem"
ENV PASS="PasswordHere123"

RUN mkdir $DATA_DIR && \
  mkdir $SERVER_DIR && \
  useradd -d $SERVER_DIR -s /bin/bash $USER && \
  chown -R $USER $DATA_DIR && \
  ulimit -n 2048 && \
  rm -rf /etc/ssh/sshd_config

ADD /configs/sshd_config /etc/ssh/sshd_config
ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && service ssh start && echo 'root:$PASS' | chpasswd

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]
