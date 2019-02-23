#!/usr/bin/perl
#
# baud
#Description: Run commands safley at their native baudrate, eg 2400, 9600, etc.
#
# This allows older commands to be executed safely at their original native baud.
# Commands are now often run over high speed telnet or ssh sessions, at speeds 
# they were not designed for - sometimes called "overbauding". Overbauding
# can cause command overheating, resulting in Command Fault Heat State Exception 
# (CFHSE) errors.
#
# Many command line programs, especially those for Unix, were orginially written
# to run at bauds such as 300, 1200, 2400 or even 9600. This was the days of serial
# connections to teletypes or dumb terminals (aka glass teletypes, green screens, 
# etc). While links to servers have increased in speed, the code for most commands
# has remained the same. Some operating systems have a man page, fastcommands(5), 
# that lists commands that are high speed link safe.
#
# Most Unix commands can be run at 2400 baud, vi or emacs may be run at 9600.
#
# 02-Jul-2005, ver 1.20
#
# USAGE: baud [-baudrate] [command]
#    eg,
#        baud ls -l                      # defaults to 2400 baud
#        baud -2400 ls -l                # running ls at 2400 baud
#        baud -9600 vi /etc/motd         # running vi at 9600 baud
#        ls -l | baud                    # read from pipe
#
# COPYRIGHT: Copyright (c) 2005 Brendan Gregg.
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software Foundation,
#  Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#  (http://www.gnu.org/copyleft/gpl.html)
#
# 08-Nov-2004	Brendan Gregg	Created this.

$| = 1;

#
#  Command Line Arguments
#
&usage() if $ARGV[0] eq "-h";
&usage() if $ARGV[0] eq "--help";
if ($ARGV[0] =~ /^-(\d+)/) {
	$baud = $1;
	shift(@ARGV);
} else {
	$baud = 2400;
}
$command = "@ARGV";
$delay = 10/$baud;


#
#  Run Command
#
if ($command ne "") {
	close(STDIN);
	open(STDIN,"$command |");
}
# else read from STDIN

#
#  Process Input
#
while (sysread(STDIN,$key,1)) {
	print $key;
	$pause += $delay;
	if ($pause > 0.01) {
		select(undef, undef, undef, $pause);
		$pause = 0;
	}
}
close STDIN;


#
#  Subroutines
#
sub usage {
	print STDERR <<END;
USAGE: baud [-baudrate] [command]
   eg,
       baud ls -l                # defaults to 2400 baud
       baud -2400 ls -l          # running ls at 2400 baud
       baud -9600 vi /etc/motd   # running vi at 9600 baud
       ls -l | baud              # read from pipe
END
	exit 1;
}


