#!/bin/bash
#Description: Generate warp drive sounds (7 variants)
#requires sox
#http://www.reddit.com/r/commandline/comments/29le5u/generate_your_own_ambient_tng_enterprise_engine/ 

play -c 2 -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +10
play -n -c1 synth whitenoise band -n 100 20 band -n 50 20 gain +25  fade h 1 864000 1
play -c2 -n synth whitenoise band -n 100 24 band -n 300 100 gain +20
play -n -c1 synth whitenoise band 100 20 compand .3,.8 -1,-10 gain +20
play -n -c2 synth whitenoise band -n 100 20 band -n 50 20 gain +20 fade h 1 864000 1 & play -n -c2 synth whitenoise lowpass -1 100 lowpass -1 50 gain +7 & play -n -c2 synth whitenoise band -n 3900 50 gain -30
play -c2 -n synth whitenoise band -n 100 24 band -n 300 100 gain +20
play -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14