#!/bin/bash
#Description: various beep patterns using the PC speaker/beeper

#Alarm beep
for n in 1 2 3 4 5 6 7 8 9 0; do
      for f in 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600; do
        beep -f $f -l 20
      done
done

# Phaser beep
n=3000; while [ $n -gt 400 ]; do beep -f $n -l 5; n=$((n*97/100)); done
#!/bin/bash
#Ring beep
for n in 1 2 3 ; do
    for f in 1 2 1 2 1 2 1 2 1 2 ; do
      beep -f ${f}000 -l 20
    done
done

#Snowtruck beep
for a in `seq 1 6`; do beep -f 1500 -l 200; beep -f 1550 -l 200; done

