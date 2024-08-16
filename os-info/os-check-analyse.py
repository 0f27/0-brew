#!/usr/bin/env python3

import json


def get_os_info_from_file(info_file):
    with open(info_file, "r") as f:
        os_info = f.read()

    os_info = "{" + os_info.split("{")[-1].replace("'", '"')
    return json.loads(os_info)


if __name__ == "__main__":
    from pprint import pprint

    pprint(get_os_info_from_file("os-check-thumbleweed.txt"))
