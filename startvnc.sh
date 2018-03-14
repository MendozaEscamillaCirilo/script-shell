#!/bin/sh

# startvnc.sh: starts x11vnc to share the desktop (DISPLAY=:0).
#              Use -f to force stop and start a new instance of x11vnc.

# Copyright © 2016 Antonio Hernández Blas <hba.nihilismus@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

TCP_PORT=5900
X11VNC=/usr/bin/x11vnc

if [ "$1" = "-f" ]; then
  # Force the start of x11vnc, so we kill any instance in execution:
  echo
  echo '=> Stoping x11vnc ...'
  killall x11vnc 2>/dev/null
else
  # Detect if there is an instance already in execution:
  if $(ps aux | grep -v grep | grep -aq x11vnc); then
    echo
    echo '=> x11vnc already listening at:'
    echo
    ip addr show | grep ' inet ' | sed 's/.* inet //' | cut -d '/' -f 1 | sed "s/$/:$TCP_PORT/" | while read socket; do
      echo $socket
    done
    # If there is an instance in execution, exit:
    echo
    exit 1
  fi
fi

# Start a new instance, in any case:
echo '=> x11vnc is going to be listening at:'
echo
ip addr show | grep ' inet ' | sed 's/.* inet //' | cut -d '/' -f 1 | sed "s/$/:$TCP_PORT/" | while read socket; do
  echo $socket
done

$X11VNC \
  -bg \
  -safer \
  -nopw \
  -viewonly \
  -geometry 1280x720 \
  -noxdamage \
  -no6 \
  -noipv6 \
  -shared \
  -forever \
  -norc \
  -nosel \
  -nolookup \
  -quiet \
  -threads \
  -display :0 1>/dev/null

echo

# EOF