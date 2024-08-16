#!/usr/bin/env python3

"""
# Notes for myself

## Categories I need

- ubuntu-based
- debian-based
- fedora-based
- arch-based

## Distros to check with this script

- [x] Linux Mint 22
- [x] Ubuntu 22.04
- [x] Ubuntu 24.04
- [x] Debian 12
- [x] Pop OS 24
- [ ] Fedora
- [ ] Silverblue
- [ ] Kubuntu
- [x] Kali
- [x] EndeavourOS
- [x] CachyOS
- [x] Manjaro
- [ ] MX Linux
- [x] OpenSuse Thumbleweed
- [x] Garuda
"""

from platform import (
    architecture,
    system,
    machine,
)


def get_os_release(filepath="/etc/os-release"):
    if system() == "Linux":
        with open(filepath, "r") as f:
            osrelease = dict(
                [
                    v.strip().replace('"', "").split("=")
                    for v in f.readlines()
                    if len(v.split("=")) == 2
                ]
            )
    else:
        osrelease = None
    return osrelease


if __name__ == "__main__":
    from pprint import pprint

    print("architecture:", architecture())
    print("system:", system())
    print("machine:", machine(), "\n")

    osrelease = get_os_release()
    print("os release file:")
    pprint(osrelease)
