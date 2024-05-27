#!/bin/bash

# $1 path to the torrent directory
# $2 torrent name
# $3 is the hash of the torrent

# copy this script to /config folder in qbittorrent container
# add the following line to qbittorrent settings in "on torrent added" section
# /config/deleteTrackerRequest.bash "/config/qBittorrent/BT_backup/%I.fastresume" %I

tracker_url=$(head -n 1 "$1/$2.tracker")
url_encoded=$(echo -n $tracker_url | jq --slurp --raw-input --raw-output @uri)
curl 'http://localhost:8080/api/v2/torrents/addTrackers' -X POST --data-raw "hash=$3&urls=$url_encoded"
rm "$1/$2.tracker"
