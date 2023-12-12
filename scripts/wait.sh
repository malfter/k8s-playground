#!/usr/bin/env bash

c=$1 # seconds to wait

PRE_MSG="Wait "
POST_MSG="s"

REWRITE="\e[25D\e[1A\e[K"
while [ $c -gt 0 ]; do
    c=$((c-1))
    sleep 1
    echo -e "${REWRITE}${PRE_MSG}$c${POST_MSG}"
done
echo -e "${REWRITE}Done."
