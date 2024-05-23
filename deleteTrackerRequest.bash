#!/bin/bash

# $1 is the file path of the torrent file
# $2 is the hash of the torrent
# $3 Sleep duartion before deleting the torrent tracker

# copy this script to /config folder in qbittorrent container
# add the following line to qbittorrent settings in "on torrent added" section
# /config/deleteTrackerRequest.bash /config/qBittorrent/BT_backup/%I.fastresume %I 4

sleep $3
tracker_url=$(sed -n 's|.*\(http[^ ]*announce\).*|\1|p' $1)
url_encoded=$(echo -n $tracker_url | jq --slurp --raw-input --raw-output @uri)
curl 'http://localhost:8080/api/v2/torrents/removeTrackers' -X POST --data-raw "hash=$2&urls=$url_encoded"
