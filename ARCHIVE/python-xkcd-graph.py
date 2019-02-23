#!/usr/bin/env python
# Source: https://ascendances.wordpress.com/2016/02/26/des-graphiques-a-la-xkcd/

from matplotlib import pyplot as plt import numpy as np

with plt.xkcd(): fig = plt.figure() ax = fig.add_subplot(1, 1, 1) ax.spines['right'].set_color('none') ax.spines['top'].set_color('none') plt.xticks([]) plt.yticks([]) ax.set_ylim([-1, 2])

x = np.linspace(0, 10)
plt.plot(x, np.sin(x) + 0.3, '--')

plt.xlabel('abscisses')
plt.ylabel('ordonnees')
plt.title("c'est le plus beau graphique du monde !")

plt.savefig("/tmp/graph_xkcd.png")

