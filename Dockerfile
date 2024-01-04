ARG PGMAJ=16
FROM postgres:$PGMAJ-bookworm
ARG PGMAJ

LABEL source="https://github.com/dotysan/adsb-postgis-docker"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --yes --no-install-recommends \
    curl \
    gcc \
    git \
    jq \
    make \
    postgis \
    postgresql-$PGMAJ-postgis-3 \
    postgresql-$PGMAJ-postgis-3-scripts \
    postgresql-plpython3-$PGMAJ \
    postgresql-server-dev-$PGMAJ \
    python3-dateutil \
    python3-dev \
    python3-pip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

ARG PIP_NO_CACHE_DIR=1

# install multicorn2
ARG MCTAG=2.5
RUN curl --location \
    https://github.com/pgsql-io/multicorn2/archive/refs/tags/v$MCTAG.tar.gz \
    |tar -xz
# this also upgrades pip >=23
RUN cd multicorn2-$MCTAG && make install && rm -rf /multicorn2-$MCTAG

RUN pip3 install --break-system-packages \
    git+https://github.com/bosth/geofdw.git@e5e59a0da0650cc8161e6097a990bb7a0b9401d5 \
    # show what pip installed where
    && pip3 list --verbose && pip3 freeze

# remove stuff only needed for build/install above
RUN apt-get --yes purge \
    gcc \
    git \
    make \
    postgresql-server-dev-$PGMAJ \
    python3-dev \
    && apt-get --yes autoremove

ADD initdb.d /docker-entrypoint-initdb.d
EXPOSE 5432
