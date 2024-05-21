#!/bin/bash

# $1 is the file path of the torrent file
# $2 is the hash of the torrent

sleep 2
tracker_url=$(sed -n 's|.*\(http[^ ]*announce\).*|\1|p' $1)
url_encoded=$(echo $tracker_url | jq --slurp --raw-input --raw-output @uri)
echo $tracker_url
curl 'http://localhost:8080/api/v2/torrents/removeTrackers' -X POST --data-raw "hash=$2&urls=$tracker_url"
