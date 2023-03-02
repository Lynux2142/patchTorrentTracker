from random import choice
from sys import argv
import re

class BadUserInputError(Exception):
    pass

def generate_tracker():
    char = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    tracker = "".join([choice(char) for i in range(32)])
    return tracker


if __name__ == "__main__":
    if len(argv) != 2:
        raise BadUserInputError("ERROR: Bad input, need torrent path")
    with open(argv[1], "r+b") as torrent:
        fake_tracker = bytes(generate_tracker(), "utf-8")
        data = torrent.read()
        current_tracker = bytes(re.search("/([A-Za-z0-9]{32})/", data[0:100].decode("utf-8")).group(1), "utf-8")
        data = data.replace(current_tracker, fake_tracker)
        torrent.seek(0)
        torrent.write(data)
        torrent.truncate()
        print(f"New tracker: {fake_tracker.decode('utf-8')}")
