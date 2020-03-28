#!/bin/bash
# Description: get the current master volume value through ALSA

amixer sget Master | grep "^  Front" | grep -ow '[0-9]*%' | head -n 1