#!/bin/bash

# $1 path to the torrent directory
# $2 torrent name
# $3 hash of the torrent
# $4 Sleep duartion before deleting the torrent tracker

# copy this script to /config folder in qbittorrent container
# add the following line to qbittorrent settings in "on torrent added" section
# /config/deleteTrackerRequest.bash "/config/qBittorrent/BT_backup/%I.fastresume" %I 4

sleep $4
tracker_url=$(grep -a -Po "https?:\/\/[^ ]*\/[a-zA-Z0-9]{32}\/announce" "$1/$2")
echo -n $tracker_url > "$1/$2.tracker"
url_encoded=$(echo -n $tracker_url | jq --slurp --raw-input --raw-output @uri)
curl 'http://localhost:8080/api/v2/torrents/removeTrackers' -X POST --data-raw "hash=$3&urls=$url_encoded"
