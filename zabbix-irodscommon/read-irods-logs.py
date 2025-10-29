#!/usr/bin/env python3


"""Prints log lines in the last hour of day, primarily meant for monitoring
"""

import argparse
from datetime import datetime, timedelta, timezone
import re


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "logfiles",
        nargs='+',
        help='The log files to search for')
    parser.add_argument("-l", "--last", default="hour", choices=["hour", "day"],
                        help="Show messages in last hour or day")
    parser.add_argument("-m", "--multi-line", action='store_true', default=False,
                        help="For multiline messages, print all lines instead of just the first one")
    return parser.parse_args()


def get_recent_timestamps(args):
    """Returns set of timestamps that are in the past hour / day.

       We precalculate recent timestamps rather than parsing the timestamp
       of each log line, since datetime operations are relatively slow,
       and production environments typically have many more log lines
       than the number of minutes in a day.
    """
    result = set()
    now = datetime.now(timezone.utc)

    if args.last == "hour":
        datetime_ref = now - timedelta(hours=1)
    else:
        datetime_ref = now - timedelta(days=1)

    while datetime_ref <= now:
        result.add(datetime.strftime(datetime_ref, "%Y-%m-%dT%H:%M"))
        datetime_ref += timedelta(minutes=1)
    return result


def process_logfile(logfile, recent_timestamps, args):
    timestamp_re = re.compile(r"^(\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}):")
    with open(logfile, "r", errors="replace") as input:
        last_line_printed = False
        for line in input:
            line_match = timestamp_re.search(line)
            if line_match:
                timestamp = line_match.group(1)
                if timestamp in recent_timestamps:
                    print(line, end="")
                    last_line_printed = True
                else:
                    last_line_printed = False
            elif args.multi_line and last_line_printed:
                print(line, end="")


def main():
    args = parse_args()
    timestamps = get_recent_timestamps(args)

    for logfile in args.logfiles:
        process_logfile(logfile, timestamps, args)


if __name__ == "__main__":
    main()
