FROM alpine:3.5
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

# Application settings
ENV CONFD_PREFIX_KEY="/gocd" \
    CONFD_BACKEND="env" \
    CONFD_INTERVAL="60" \
    CONFD_NODES="" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    LANG="en_US.utf8" \
    APP_HOME="/opt/gocd" \
    APP_VERSION="17.3.0-4704" \
    SCHEDULER_VOLUME="/opt/scheduler" \
    USER=gocd \
    GROUP=gocd \
    UID=10003 \
    GID=10003 \
    CONTAINER_NAME="alpine-gocd-agent" \
    CONTAINER_AUHTOR="Sebastien LANGOUREAUX <linuxworkgroup@hotmail.com>" \
    CONTAINER_SUPPORT="https://github.com/disaster37/alpine-gocd-agent/issues" \
    APP_WEB="https://www.gocd.io"

# Install extra package
RUN apk --update add fping curl tar bash openjdk8-jre-base git mercurial subversion make docker py-pip sudo &&\
    pip install docker-compose &&\
    echo "gocd ALL=NOPASSWD: ALL" >> /etc/sudoers &&\
    rm -rf /var/cache/apk/*

# Install confd
ENV CONFD_VERSION="v0.13.7" \
    CONFD_HOME="/opt/confd"
RUN mkdir -p "${CONFD_HOME}/etc/conf.d" "${CONFD_HOME}/etc/templates" "${CONFD_HOME}/log" "${CONFD_HOME}/bin" &&\
    curl -sL https://github.com/yunify/confd/releases/download/${CONFD_VERSION}/confd-alpine-amd64.tar.gz \
    | tar -zx -C "${CONFD_HOME}/bin/"

# Install s6-overlay
RUN curl -sL https://github.com/just-containers/s6-overlay/releases/download/v1.19.1.1/s6-overlay-amd64.tar.gz \
    | tar -zx -C /


# Install GoCD agent software
RUN \
    mkdir -p ${APP_HOME} /data /data/config  && \
    curl https://download.gocd.io/binaries/${APP_VERSION}/generic/go-agent-${APP_VERSION}.zip -o /tmp/go-agent.zip &&\
    unzip /tmp/go-agent.zip -d /tmp &&\
    mv /tmp/go-agent-*/* ${APP_HOME}/ &&\
    rm -rf /tmp/go-server-* &&\
    addgroup -g ${GID} ${GROUP} && \
    adduser -g "${USER} user" -D -h ${APP_HOME} -G ${GROUP} -s /bin/sh -u ${UID} ${USER}

# Install Rancher compose cli
ENV RANCHER_CLI_VERSION "v0.12.4"
RUN curl -sL https://github.com/rancher/rancher-compose/releases/download/${RANCHER_CLI_VERSION}/rancher-compose-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz \
    | tar -zx -C /usr/bin/

ADD root /
RUN chown -R ${USER}:${GROUP} ${APP_HOME}


VOLUME ["/data"]
CMD ["/init"]