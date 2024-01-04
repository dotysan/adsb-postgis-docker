#! /usr/bin/env bash
set -ex

AIRPORTS='http://downloads.adsbexchange.com/downloads/basic-ac-db.json.gz'
JQ_FILTER='"\(.icao)\t\(.reg // "\\N")\t\(.icaotype // "\\N")\t\((if .year == "" then "\\N" else .year end) // "\\N")\t\(.manufacturer // "\\N")\t\(.model // "\\N")\t\(.ownop // "\\N")\t\(.faa_pia)\t\(.faa_ladd)\t\(.short_type // "\\N")\t\(.mil)"'
SQL='BEGIN; COPY aircraft FROM stdin; COMMIT;'

curl --location "$AIRPORTS" |zcat \
    |jq --raw-output "$JQ_FILTER" \
    |psql --dbname adsb --command "$SQL"
