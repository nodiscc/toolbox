#!/bin/bash
#Description: very low filtered white noise, test on large speakers
play -n -c1 \
synth whitenoise band \
-n 100 20 band \
-n 50 20 gain +25 \
fade h 1 864000 1

