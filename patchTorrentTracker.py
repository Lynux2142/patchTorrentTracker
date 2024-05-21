from random import choice
from sys import argv
import re
from time import sleep

class BadUserInputError(Exception):
    pass

def generate_tracker():
    char = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    tracker = "".join([choice(char) for i in range(32)])
    return tracker


if __name__ == "__main__":
    if len(argv) == 2:
        new_tracker = bytes(generate_tracker(), "utf-8")
    elif len(argv) == 3:
        new_tracker = bytes(argv[2], "utf-8")
    else:
        raise BadUserInputError("ERROR: Bad input\nUsage: python3 patchTorrentTracker.py [path/to/torrent/file] ([new_tracker])")
    sleep(2)
    with open(argv[1], "r+b") as torrent:
        data = torrent.read()
        r = re.compile(b"/([A-Za-z0-9]{32})/", re.DOTALL)
        old_tracker = r.search(data).group(1)
        data = data.replace(old_tracker, new_tracker)
        torrent.seek(0)
        torrent.write(data)
        torrent.truncate()
        print(f"Old tracker: {old_tracker.decode('utf-8')}")
        print(f"New tracker: {new_tracker.decode('utf-8')}")
