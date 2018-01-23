#!/bin/bash
hex_file="$1"
chip=${2-x32a4u}
[ $# -eq 0 ] && { echo "Usage: $0 <hex file> [optional <chip> (default x32a4u)]" ; exit 1; }
avrdude -c avrispmkii -p $chip -P usb -U flash:w:$hex_file:i
