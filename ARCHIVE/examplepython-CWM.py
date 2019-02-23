#! /usr/bin/python
#Description: CWM tests and trains complex working memory"""
##################################################################################
# CWM is a program to test and train complex working memory
#                                                          
# Most of the program is based on details gleaned from
# "Can You Make Yourself Smarter?"
# by Dan Hurley, New York Times, 18 April, 2012
# as well as "The generality of working memory capacity:
# a latent-variable approach to verbal and visuospatial memory span and reasoning"
# by Kane, et. al., J. Exp. Psychol. Gen., 2004
#
# Copyright (C) 2012: Brandon Milholland
# brandon dot milholland at gmail dot com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
##################################################################################





import time
import random
import curses
import argparse
import datetime


def main():
    """The main function of the program"""
    
    parser = argparse.ArgumentParser()
    parser.add_argument("-l", "--log",
                        default="./.CWMlog",
                        type=argparse.FileType('a'))
    parser.add_argument("-s", "--start",
                        default=2, type=int)
    parser.add_argument("--square", action="store_true")
    parser.add_argument("--sym_square", action="store_true")
    parser.add_argument("--loc_first", action="store_true")
    parser.add_argument("--sym_time", default=0, type=float)
    parser.add_argument("--sym_num", default=3, type=int)
    args = parser.parse_args()
    logfile = args.log

    fill_window(stdscr, " ", pair=1)
    prev_results = list()
    prev_trials = 0 #Previous trials *at the current level*
    
    if(args.start<1):
        args.start = 2
    level = args.start

    while True:
        if not begin_prompt(level):
            return 0
        else:
            prev_results.append(task(level,
                                     square=args.square,
                                     sym_square=args.sym_square,
                                 loc_first=args.loc_first,
                                 sym_time=args.sym_time,
                                 sym_num=args.sym_num))
            prev_trials += 1
            now = datetime.datetime.now()
            if prev_results[-1]:
                result = "Success"
            else:
                result = "Fail"
            log_entry = "".join([str(now.month).zfill(2),
                                "/", str(now.day).zfill(2), ", ",
                                str(now.year), "\t",
                                str(now.hour).zfill(2),
                                ":", str(now.minute).zfill(2),
                                ":", str(now.second).zfill(2), "\t",
                                 str(level), "\t", result, "\n"])
            logfile.write(log_entry)
            
            if prev_trials < 2:
                continue
            if prev_results[-1] and prev_results[-2]:
                level += 1
                prev_trials = 0
            if not (prev_results[-1] or prev_results[-2]):
                level = max(1, level-1)
                prev_trials = 0

def fill_window(win, char, pair=0):
    """Fills window win with character char"""
    height, width = win.getmaxyx()
    string = char*(width-1)
    for line in range(height):
        win.addstr(line, 0 , string, curses.color_pair(pair))
    win.refresh()
        
def printc(message, window, pair=0, yoffset=0, attribute=0, xoffset=0):
    """Prints a message in the center of a window, with an optional offset"""
    rows, cols = window.getmaxyx()
    window.addstr(rows//2+yoffset, (cols-len(message))//2+xoffset, message,
                  curses.color_pair(pair) | attribute)
    window.refresh()
                         
def task(level, square=False, sym_square=False, loc_first=False, sym_time=0, sym_num=3):
    """Performs the complex working memory span task at a given level"""
    result = True
    locations = list()
    if loc_first:
        for i in range(level):
            locations.append(random.randint(0, 15))
            display_location(locations[i], square=square)
            result =  symmetry_tasks(square=sym_square,
                                     time_limit=sym_time, num=sym_num) and result
    else:
        for i in range(level):
            result =  symmetry_tasks(square=sym_square,
                                     time_limit=sym_time, num=sym_num)and result
            locations.append(random.randint(0, 15))
            display_location(locations[i], square=square)
    result = recall_prompt(locations, square=square) and result
    return result

def begin_prompt(level):
    """The initial prompt for the program."""
    fill_window(stdscr, " ", pair=1)
    printc("Complex Working Memory Span Testing and Training Program",
           stdscr, pair=1, yoffset=-10)
    printc("Current level: "+str(level), stdscr, pair=1)
    key = ""
    printc("Press enter to begin testing, h for help or q to quit.",
           stdscr, yoffset=1, pair=1)
    printc("Copyright (C) 2012: Brandon Milholland", stdscr, yoffset=10, pair=1)
    printc("Distributed under the GNU Affero General Public License",
           stdscr, yoffset=11, pair=1)
    commands = (ord("c"), ord("q"), ord(" "), ord("\n"))
    cont_commands = (ord("c"), ord(" "), ord("\n"))
    while(key not in commands):
        key = stdscr.getch()
        if key in cont_commands:
            return True
        if key == ord("q"):
            return False
        if key == ord("h"):
            printc("This is a program to test and train your complex working memory.",
                   stdscr, yoffset=2, pair=1)
            printc("You will first be asked to determine if a series of patterns have left/right symmetry. Hit y or the right arrow key for yes, n or the left arrow key for no.", stdscr, yoffset=3, pair=1)
            printc("After every three symmetry problems, you will be show the location of a star in a 4x4 grid and asked to remember it for later.", stdscr, yoffset=4, pair=1)
            printc("This cycle will repeat itself a number of times, after which you will be asked to recall the locations of the stars in the order they were shown.", stdscr, yoffset=5, pair=1)
            printc("Use the arrow keys to move around the star and press enter or the spacebar to select the location.", stdscr, yoffset=6, pair=1)
            printc("Depending on how you perform, the program will automatically increase or decrease your level and the number of locations you are asked to remember.", stdscr, yoffset=7, pair=1)
            printc("This will keep the task challenging but not overwhelming.",
                   stdscr, yoffset=8, pair=1)
            printc("Try to see how high you can get the level!",
                   stdscr, yoffset=9, pair=1)
            
        
def symmetry_tasks(square=False, time_limit=0, num=3):
    """Gives the user symmetry tasks to do with a specified timeout and/or minimum number of tasks"""
    result = True
    if time_limit > 0:
        start = time.time()
        i = 0
        while(time.time() < start+time_limit or i<num):
            result = symmetry_prompt(square=square) and result
            i = i+1
    else:
        for i in range(num):
            result = symmetry_prompt(square=square) and result
    return result

def symmetry_prompt(square=False):
    """Prompts the user to determine the symmetry of 3 random 8x8 matrices"""
    result = True
    symmetrical = random.randint(0, 1)
    if symmetrical:
        display_matrix(generate_symmetrical(), square=square)
    else:
        display_matrix(generate_asymmetrical(), square=square)
                                
    key = ""
    printc("Is this pattern symmetrical?", stdscr, pair=1, yoffset=8)
    printc("y/n", stdscr, pair=1, yoffset=9)
    commands = (ord("y"), ord("n"), curses.KEY_LEFT, curses.KEY_RIGHT)
    ans = ""
    while(key not in commands):
        key = stdscr.getch()
        if key == ord("y") or key == curses.KEY_RIGHT:
            result = result and symmetrical
            ans = "y"
                    
                
        if key == ord("n") or key == curses.KEY_LEFT:
            result = result and not symmetrical
            ans = "n"
                
        if (ans == "y" and symmetrical) or (ans == "n" and not symmetrical):
            printc("Right", stdscr, pair=1, yoffset=9)
        elif key in commands:
            printc("Wrong", stdscr, pair=1, yoffset=9)
        time.sleep(.5)
        fill_window(stdscr, " ", pair=1)
    return result

def display_matrix(matrix, square=False):
    """Displays a matrix in the center of stdscr"""
    fill_window(stdscr, " ", pair=1)
    i = 0
    if square:
        for row in matrix:
            printc(" ".join(row), stdscr, pair=1, yoffset=i)
            i += 1
    else:
        for row in matrix:
            printc(row, stdscr, pair=1, yoffset=i)
            i += 1

def generate_asymmetrical():
    """Generates a matrix guaranteed to be asymmetrical"""
    matrix = rand_matrix()
    while is_symmetrical(matrix):
        matrix = rand_matrix()
    return matrix
    

def is_symmetrical(matrix):
    """Checks if a matrix is symmetrical"""
    result = True
    for i in range(8):
        row = matrix[i*8:(i+1)*8]
        result = result and (row[0:3] == row[4:])
    return result
                    
    
def rand_matrix():
    """Generates a random matrix highly unlikely (<0.02%) to be symmetrical"""
    matrix = list()
    for i in range(8):
        row = ""
        for j in range(8):
            if(random.randint(0, 1) == 0):
                row += "O"
            else:
                row += "*"
        matrix.append(row)
    return matrix

def generate_symmetrical():
    """Generates a matrix guaranteed to be symmetrical"""
    matrix = list()
    for i in range(8):
        row = ""
        for j in range(4):
            if(random.randint(0, 1) == 0):
                row += "O"
            else:
                row += "*"
        row += row[::-1]
        matrix.append(row)
    return matrix

def display_location(location, square=False):
    """Displays a location to be memorized"""
    fill_window(stdscr, " ", pair=1)
    printc("Remember the location of the star.", stdscr, pair=1)
    grid = 16*"O"
    grid = grid[0:location]+"*"+grid[location+1:]
    if square:
        for i in range(4):
            printc(" ".join(grid[i*4:(i+1)*4]), stdscr, yoffset=1+i, pair=1)
    else:
        for i in range(4):
            printc(grid[i*4:(i+1)*4], stdscr, yoffset=1+i, pair=1)
    time.sleep(.65)
    fill_window(stdscr, " ", pair=1)
    time.sleep(.5)

def recall_prompt(locations, square=False):
    """Prompts the user to recall a series of locations"""
    i = 1
    result = True
    for loc in locations:
        fill_window(stdscr, " ", pair=1)
        printc("Where was location "+str(i)+"?", stdscr, pair=1)
        printc("Use the arrow keys to move the star and press space or enter to select.",
               stdscr, yoffset=5, pair=1)
        key = ""
        cursor_pos = [0, 0]
        rows, cols = stdscr.getmaxyx()
        if cols % 2 == 0:
            xoffset = 2
        else:
            xoffset = 1
        upper_left = [rows//2+1, (cols-4)//2]
        commands = (ord(" "), ord("\n"))
        
        while key not in commands:
            if square:
                for j in range(4):
                    printc(" ".join(4*"O"), stdscr, pair=1, yoffset=1+j)
                    stdscr.addch(upper_left[0]+cursor_pos[0],
                                 upper_left[1]+2*cursor_pos[1]-xoffset,
                                 "*", curses.color_pair(1))
                    stdscr.refresh()
            else:
                for j in range(4):
                    printc(4*"O", stdscr, pair=1, yoffset=1+j)
                    stdscr.addch(upper_left[0]+cursor_pos[0],
                                 upper_left[1]+cursor_pos[1],
                                 "*", curses.color_pair(1))
                    stdscr.refresh()
            key = stdscr.getch()
           
            if key == curses.KEY_UP:
                cursor_pos[0] = max(0, cursor_pos[0]-1)
            elif key == curses.KEY_DOWN:
                cursor_pos[0] = min(3, cursor_pos[0]+1)
            elif key == curses.KEY_LEFT:
                cursor_pos[1] = max(0, cursor_pos[1]-1)
            elif key == curses.KEY_RIGHT:
                cursor_pos[1] = min(3, cursor_pos[1]+1)

        if 4*cursor_pos[0]+cursor_pos[1] == loc:
            printc("Correct", stdscr, pair=1, yoffset=6)
            result = result and True
        else:
            printc("Incorrect", stdscr, pair=1, yoffset=6)
            result = result and False
        time.sleep(.5)
        i += 1
    return result
    

            


random.seed()
stdscr = curses.initscr()
curses.start_color()
curses.cbreak()
curses.noecho()
stdscr.keypad(1)

curses.init_pair(1, curses.COLOR_RED, curses.COLOR_WHITE)
curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLUE)
curses.curs_set(0) 



try:         
    main()

finally:
    curses.nocbreak()
    stdscr.keypad(0)
    curses.echo()
    curses.endwin()


