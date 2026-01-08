#!/usr/bin/env python3

"""This Zabbix check script tests whether iRODS
   is available.

   It outputs '0' if iRODS is responding within a
   reasonable amount of time, otherwise '1'"""

import subprocess
from typing import List, Optional


def get_process_returncode_with_timeout(
        args: List[str], timeout: int) -> Optional[int]:
    returncode: Optional[int] = None
    try:
        process = subprocess.run(args,
                                 capture_output=True,
                                 text=True,
                                 timeout=timeout)
        returncode = process.returncode
    except subprocess.TimeoutExpired:
        pass
    return returncode


def main():
    returncode = get_process_returncode_with_timeout(["/usr/bin/ils", "/"],
                                                     10)
    if returncode is None or returncode > 0:
        print(1)
    else:
        print(0)


if __name__ == "__main__":
    main()
