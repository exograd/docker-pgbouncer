FROM ubuntu:20.04

ENV PGBOUNCER_VERSION "1.16.0"
ENV PGBOUNCER_SHA256 "a4a391618bb83caaee2a8cd9653974f4c1b98b95987d5cabbbeb801da6342652  pgbouncer-1.16.0.tar.gz"

RUN apt-get update -y && \
    apt-get upgrade \
      -y \
      --no-install-recommends \
      ca-certificates \
      libssl-dev \
      build-essential \
      pkg-config \
      libevent-dev \
      curl && \
    curl \
      -sSo /tmp/pgbouncer-$PGBOUNCER_VERSION.tar.gz \
      "https://www.pgbouncer.org/downloads/files/$PGBOUNCER_VERSION/pgbouncer-$PGBOUNCER_VERSION.tar.gz" && \
    cd /tmp && \
    echo $PGBOUNCER_SHA256 | sha256sum --check && \
    tar -xzf pgbouncer-$PGBOUNCER_VERSION.tar.gz && \
    cd pgbouncer-$PGBOUNCER_VERSION && \
    ./configure --prefix=/usr/local/ && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/pgbouncer-$PGBOUNCER_VERSION.tar.gz && \
    rm -rf /tmp/pgbouncer-$PGBOUNCER_VERSION && \
    groupadd -g 2001 pgbouncer && \
    useradd -m -g pgbouncer -u 2001 pgbouncer && \
    apt-get remove \
      --purge \
      -y \
      --allow-remove-essential \
      build-essential \
      curl \
      pkg-config \
      ca-certificates && \
    apt-get autoremove -y && \
    apt-get clean -y

USER pgbouncer:pgbouncer

ENTRYPOINT ["/usr/local/bin/pgbouncer", "-u", "pgbouncer"]
