#!/usr/bin/python
#Description: A simple library for making ASCII art from images.

"""
  ASCII Art Generator

  A simple library for making ASCII art from images.
  Uses Pygame for its nice image handling functions.

  Need to add support for getting the correct aspect ratio - pixels are square, but characters are usually 7x12.

  Also, yellow/orange and blue are swapped. This should be an easy fix, but I can't find where it's broken.

  Source: http://redd.it/omig9

"""

import sys

NAME = sys.argv[0]
VERSION = "0.1.0" # The current version number.

HELP = """ {0} : An ASCII art generator. Version {1}
Usage:
    {0} [-b BLOB_SIZE] [-p FONT_WIDTH:HEIGHT] [-c] image_filename

Commands:
    -b | --blob            Change the blob size used for grouping pixels. This is the width of the blob; the height is calculated by multiplying the blob size by the aspect ratio.
    -p | --pixel-aspect    Change the font character aspect ratio. By default this is 11:5, which seems to look nice. Change it based on the size of your font. Argument is specified in the format "WIDTH:HEIGHT". The colon is important.
    -c | --colour          Use colour codes in the output. {0} uses VT100 codes by default, limiting it to 8 colours, but this might be changed later.

    -h | --help            Shows this help.
""".format(NAME, VERSION)

NO_IMAGE = \
    """ Usage: %s [-b BLOB_SIZE] [-p FONT_WIDTH:HEIGHT] image_filename """ % (NAME)

import math

CAN_HAS_PYGAME = False
try:
    import pygame
except ImportError:
    sys.stderr.write("Can't use Pygame's image handling! Unable to proceed, sorry D:\n")
    exit(-1)

VT100_COLOURS = {"000": "[0;30;40m",
                 "001": "[0;30;41m",
                 "010": "[0;30;42m",
                 "011": "[0;30;43m",
                 "100": "[0;30;44m",
                 "101": "[0;30;45m",
                 "110": "[0;30;46m",
                 "111": "[0;30;47m",
                 "blank": "[0m"}

VT100_COLOURS_I = {"000": "[0;40;30m",
                   "001": "[0;40;31m",
                   "010": "[0;40;32m",
                   "011": "[0;40;33m",
                   "100": "[0;40;34m",
                   "101": "[0;40;35m",
                   "110": "[0;40;36m",
                   "111": "[0;40;37m",
                   "blank": "[0m"}

# Convenient debug function.
DO_DEBUG = True
def debug(*args):
    if not DO_DEBUG: return # Abort early, (but not often).
    strrep = ""
    for ii in args:
        strrep += str(ii)
    sys.stderr.write(strrep + "\n") # Write it to stderr. Niiicce.

# System init.
def init():
    """ Start the necessary subsystems. """
    pygame.init() # This is the only one at the moment...

# Get a section of the surface.
def getSubsurface(surf, x, y, w, h):
    try:
        return surf.subsurface(pygame.Rect(x, y, w, h))
    except ValueError as er:
        return getSubsurface(surf, x, y, w - 2, h - 2)

# The main class.
class AAGen:
    """ A class to turn pictures into ASCII "art". """
    def  __init__(self):
        """ Set things up for a default conversion. """

        # Various blob settings.
        self.aspectRatio = 11.0 / 5.0 # The default on my terminal.
        self.blobW = 12 # The width. Also, the baseline for aspect ratio.
        self.blobH = self.aspectRatio * self.blobW # The height.

        self.blobList = []
        self.cat = None # The currently open file.
        self.chars = """#@%H(ks+i,. """ # The characters to use.
        
        self.colour = False # Do we use colour?

    def processArgs(self):
        """ Process the command line arguments, and remove any pertinent ones. """
        cc = 0
        for ii in sys.argv[1:]:
            cc += 1

            if ii == "-b" or ii == "--blob":
                self.setBlob(int(sys.argv[cc + 1]))

            elif ii == "-p" or ii == "--pixel-aspect":
                jj = sys.argv[cc + 1]
                self.setAspect(float(jj.split(":")[1]) / float(jj.split(":")[0]))
            elif ii == "-c" or ii == "--colour":
                self.colour = True
                
            elif ii == "-h" or ii == "--help":
                print(HELP)
                exit(0)
        
        if len(sys.argv) == 1:
            print(NO_IMAGE)
            exit(0)

    def setBlob(self, blobW):
        """ Set the blob size. """
        self.blobW = blobW
        self.blobH = int(math.ceil(self.aspectRatio * self.blobW))

    def setAspect(self, aspect):
        """ Set the aspect ratio. Also adjust the blob height. """
        self.aspectRatio = aspect
        self.blobH = int(math.ceil(self.blobW * self.aspectRatio))

    def loadImg(self, fname):
        """ Loads an image into the store. """
        try:
            tmpSurf = pygame.image.load(fname)
        except:
            print("Either this is an unsupported format, or we had problems loading the file.")
            return None
        self.cat = tmpSurf.convert(32)
        
        if self.cat == None:
            sys.stderr.write("Problem loading the image %s. Can't convert it!\n"
                             % fname)
            return None
    
    def makeBlob(self, section):
        """ Blob a section into a single ASCII character."""
        pxArr = pygame.surfarray.pixels3d(section)
        colour = [0, 0, 0]
        size = 0 # The number of pixels.

        # Get the density/colours.
        for i in pxArr:
            for j in i:
                size += 1 
                # Add to the colour.
                colour[0] += j[0]
                colour[1] += j[1]
                colour[2] += j[2]

        # Get just the greyscale.
        grey = apply(lambda x, y, z: (x + y + z) / 3 / size,
                     colour)
        
        if self.colour:
            # Get the 3 bit colour.
            threshold = 128
            nearest = ""
            nearest += "1" if (colour[0] / size > threshold) else "0"
            nearest += "1" if (colour[1] / size > threshold) else "0"
            nearest += "1" if (colour[2] / size > threshold) else "0"

            return VT100_COLOURS[nearest], grey

        return grey

        # We just use a nasty mean function to find the average value.
#        total = 0
#        for pix in pxArr.flat:
#            total += pix # flat is the array as a single-dimension one.

#        return total / pxArr.size # This is a bad way to do it, it loses huge amounts of precision with large blob size. However, with ASCII art...

    def getBlobs(self):
        """ Get a list of blob locations. """
        self.blobList = [] # Null it out.
        width, height = self.cat.get_width(), self.cat.get_height()

        # If the image is the wrong size for blobs, add extra space.
        if height % self.blobH != 0 or width % self.blobW != 0:
            oldimg = self.cat
            newW = width - (width % self.blobW) + self.blobW
            newH = height - (height % self.blobH) + self.blobH
            self.cat = pygame.Surface((newW, newH))

            self.cat.fill((255, 255, 255))
            self.cat.blit(oldimg, pygame.Rect(0, 0, newW, newH))

        # Loop over subsections.
        for row in range(0, height, int(self.blobH)):
            rowItem = []
            for column in range(0, width, self.blobW):
                # Construct a Rect to use.
                src = pygame.Rect(column, row, self.blobW, self.blobH)
                # Now, append the reference.
                rowItem.append(self.cat.subsurface(src))
            self.blobList.append(rowItem)

        return self.blobList

    def getCharacter(self, value, colour = False):
        """ Get the correct character for a pixel value. """
        col = value[0] if colour else ""
        value = value[1] if colour else value
        if not 0 <= value <= 256:
            sys.stderr.write("Incorrect pixel data provided! (given %d)\n"
                             % value)
            return "E"
        char = self.chars[int(math.ceil(value / len(self.chars))) % len(self.chars)]
        return char + col

    def convertImage(self, fname):
        """ Convert an image, and print it. """
        self.loadImg(fname)
        self.getBlobs()

        pval = "" # The output value.
        # Loop and add characters.
        for ii in converter.blobList:
            for jj in ii:
                ch = self.makeBlob(jj)
                pval += self.getCharacter(ch, self.colour) # Get the character.
            # Reset the colour at the end of the line.
            if self.colour: pval += VT100_COLOURS["blank"]

            pval += "\n" # Split it up by line.
        pval = pval[:-1] # Cut out the final newline.

        print(pval) # Print it.

# Main program execution.
if __name__ == "__main__":
    init()

    converter = AAGen()

    converter.processArgs()
    converter.convertImage(sys.argv[-1])
