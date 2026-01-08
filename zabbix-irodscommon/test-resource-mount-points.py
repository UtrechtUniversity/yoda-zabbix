#!/usr/bin/env python3

"""This Zabbix check script verifies whether iRODS unixfilesystem
   resources vault directories are accessible.

   Printed value:
   '0'  if resources cannot be listed (e.g. iRODS is not available).
        Such problems needs to be detected by another separate check.

   Otherwise it prints the number of local vault directories that cannot
   be detected as available.

   In order for this check to work as expected, vault directories always
   need to be a subdirectory of the mount point of a volume. If the vault
   directory is the same as the mount point of the volume, the check script
   has no reliable way to differentiate an unmounted volume from an empty
   vault directory, and will therefore not detect any issues.
"""

import socket
import subprocess
import sys
from typing import Dict, List, Optional, Tuple


def get_process_output_with_timeout(
        args: List[str], timeout: int) -> Tuple[Optional[int], Optional[str]]:
    returncode: Optional[int] = None
    output: Optional[str] = None
    try:
        process = subprocess.run(args,
                                 capture_output=True,
                                 text=True,
                                 timeout=timeout)
        returncode = process.returncode
        output = process.stdout
    except subprocess.TimeoutExpired:
        pass
    return returncode, output


def directory_exists_and_fs_accessible(path: str, timeout: int) -> bool:
    returncode, _ = get_process_output_with_timeout(
        ["/bin/test", "-d", path], 1)
    return returncode == 0


def get_hostname() -> str:
    return socket.getfqdn()


def get_resource_data() -> Optional[List[Dict[str, str]]]:
    returncode, output = get_process_output_with_timeout(
        ["/bin/ilsresc", "-l"], 10)
    if returncode is None or output is None:
        return None

    resourcedata: List[Dict[str, str]] = []
    current_data: Dict[str, str] = dict()
    for line in output.split("\n"):
        line = line.rstrip()
        if ":" in line:
            keyvalue = line.split(":")[0]
            value = ":".join(line.split(":")[1:]).lstrip()
            current_data[keyvalue] = value
        elif line.startswith("----"):
            resourcedata.append(current_data)
            current_data = dict()
    if len(current_data) > 0:
        resourcedata.append(current_data)

    return resourcedata


def get_num_local_ufs_vault_path_errors(
        resourcedata: List[Dict[str, str]], hostname: str) -> int:
    num_errors: int = 0
    for resource in resourcedata:
        resource_desc = resource.get("resource name", "unknown resource")
        resource_loc = resource.get("location", None)
        resource_type = resource.get("type", None)
        if (resource_type == "unixfilesystem" and
                resource_loc == hostname):
            path = resource.get("vault", None)
            if path is None:
                print(
                    sys.stderr,
                    f"Warning: UFS resource without vault path: {resource_desc}")
            elif not directory_exists_and_fs_accessible(path, 2):
                num_errors += 1
    return num_errors


def main():
    resourcedata = get_resource_data()

    if resourcedata is None:
        print(0)
    else:
        num_errors = get_num_local_ufs_vault_path_errors(resourcedata,
                                                         get_hostname())
        print(num_errors)


if __name__ == "__main__":
    main()
