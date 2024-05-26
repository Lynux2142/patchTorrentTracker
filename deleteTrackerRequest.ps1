<#
.SYNOPSIS
Removes the tracker URL from a torrent in the qBittorrent client.

.DESCRIPTION
This script is designed to be used in the qBittorrent client's "on torrent added" section.
It takes two parameters:
1. $1 - The file path of the torrent file
2. $2 - The hash of the torrent
3. $3 - Number of seconds before deleting the tracker

The script copies the tracker URL from the torrent file, URL-encodes it, and then sends a POST request to the qBittorrent API to remove the tracker URL from the torrent.

.PARAMETER TorrentFilePath
The file path of the torrent file.

.PARAMETER TorrentHash
The hash of the torrent.

.PARAMETER SleepDuration
Number of seconds before deleting the tracker

.EXAMPLE
powershell.exe -executionpolicy bypass .\deleteTrackerRequest.ps1 c:\Users\UserName\Downloads\{TorrentName}.torrent {TorrentHash} 4

Put this script in the qBittorrent installation directory and add this command in the "on torrent added" section of the qBittorrent client (don't forget to enable WebUI in the settings and set the port to 8080):

powershell.exe -executionpolicy bypass .\deleteTrackerRequest.ps1 "c:\Users\{username}\Downloads\%N.torrent" %I 4
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$TorrentFilePath,
    [Parameter(Mandatory=$true)]
    [string]$TorrentHash,
    [Parameter(Mandatory=$true)]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$SleepDuration
)

Add-Type -AssemblyName System.Web

Start-Sleep -Seconds $SleepDuration

$trackerUrl = (Get-Content -Path $TorrentFilePath | Select-String -Pattern 'http[^ ]*announce' -AllMatches).Matches.Value
$urlEncoded = [System.Web.HttpUtility]::UrlEncode($trackerUrl)

$apiUrl = 'http://localhost:8080/api/v2/torrents/removeTrackers'
$body = "hash=$TorrentHash&urls=$urlEncoded"

Invoke-WebRequest -Uri $apiUrl -Method Post -Body $body
