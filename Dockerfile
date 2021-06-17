FROM ubuntu:20.04

ENV PGBOUNCER_VERSION "1.15.0"

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
      -sSo /tmp/bouncer.tar.gz \
      "https://www.pgbouncer.org/downloads/files/1.15.0/pgbouncer-$PGBOUNCER_VERSION.tar.gz" && \
    cd /tmp && \
    tar -xzf bouncer.tar.gz && \
    cd pgbouncer-$PGBOUNCER_VERSION && \
    ./configure --prefix=/usr/local/ && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/pgbouncer.tar.gz && \
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
