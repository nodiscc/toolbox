#!/usr/bin/perl
#
#l33t - auto l33t converter. Perl, Unix.
#
# Description: This program converts text to l33t-speak.
# This is helpful to convert text
# that has been written in a formal and confusing manner, into text that 
# is easy to follow.
#
# 16-Jun-2005   ver 0.80
#
# USAGE: l33t [-abnuv] textfile
#
#        l33t -a     # all
#        l33t -b     # basic-l33t
#        l33t -n     # normal-l33t (default)
#        l33t -u     # ultra-l33t
#        l33t -v     # verbose
#    eg,
#        l33t message.txt
#        man ls | l33t | more
#
# SEE ALSO: gwhiz(1)
#
# THANKS: Boyd Adamson
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
# 16-Jun-2005   Brendan Gregg   Created this.

use Getopt::Std;
$| = 1;

#
#  Command Line Arguments
#
&usage() if $ARGV[0] eq "--help";
getopts('abnuv') || &usage();
&usage() if $opt_h;
$BASIC = 1  if $opt_b || $opt_a || $opt_u || $opt_n;
$NORMAL = 1 if $opt_n || $opt_a || $opt_u;
$ULTRA = 1  if $opt_u || $opt_a;
$VERBOSE = 1 if $opt_v || $opt_a;
if (($BASIC + $NORMAL + $ULTRA) == 0) { 
	$BASIC = 1;
	$NORMAL = 1;
}
@Superlatives = ("w00t!","haxx0r","l33t!","d00d");

#
#  l33t Data
#
while ($line = <>) {
	chomp($line);
	l33t($line);
	print "$line\n";
}


#################
#  Subroutines
#

# l33t - l33t the input variable.
#       This function will write to the input variable,
#       similar to chomp.
#
sub l33t {
	$line = shift;     # not my
	my ($char,$new);
	$new = "";

	basic_l33t($line) if $BASIC;
	normal_l33t($line) if $NORMAL;
	ultra_l33t($line) if $ULTRA;

	if ($VERBOSE) {
		if ( int(rand(3)) == 0) {
			$index = int(rand(@Superlatives));
			$line .= " $Superlatives[$index]";
		}
	}
}

# basic_l33t - convert the argument string to basic l33t speak.
#	this code is order dependant.
#
sub basic_l33t {
	$line = shift;     # not my
	my ($char, $new);

	### word conversions
	$line =~ s/\byou\b/int(rand(2))==0?"u":"you"/ieg;
	$line =~ s/\bare\b/int(rand(2))==0?"r":"are"/ieg;
	
	### combo conversions
	$line =~ s/s\b/int(rand(5))!=0?"z":"s"/eg;
	$line =~ s/\bf/int(rand(2))==0?"ph":"f"/ieg;

	foreach $char (split(//,$line)) {

		### character conversions
		if ($char eq "a" && int(rand(4)) == 0) { $char = "4"; }
		if ($char eq "e" && int(rand(3)) == 0) { $char = "3"; }
		if ($char eq "l" && int(rand(3)) == 0) { $char = "1"; }
		if ($char eq "o" && int(rand(3)) == 0) { $char = "0"; }
		if ($char eq "s" && int(rand(4)) == 0) { $char = '5'; }

		$new .= $char;
	}
	$line = $new;

	### exclimation marks
	if ($line !~ /^\s*$/) {
		$line .= "!" x int(rand(3));
	}
}

# normal_l33t - convert the argument string to normal l33t speak.
#	this code is order dependant.
#
sub normal_l33t {
	$line = shift;     # not my
	my ($char, $new);

	### word conversions
	$line =~ s/\broot\b/w00t/ig;
	$line =~ s/\bfiles?\b/int(rand(2))==0?"warez":"files"/ieg;
	
	### combo conversions
	$line =~ s/cks\b/int(rand(2))==0?"x":"cks"/eg;
	$line =~ s/er\b/int(rand(2))==0?"or":"er"/eg;

	foreach $char (split(//,$line)) {
		$char = lc($char);

		### character conversions
		if ($char eq "a" && int(rand(4)) == 0) { $char = "@"; }
		if ($char eq "s" && int(rand(4)) == 0) { $char = '$'; }
		if ($char eq "s" && int(rand(6)) == 0) { $char = "z"; }
		if ($char eq "t" && int(rand(4)) == 0) { $char = "7"; }
		if (int(rand(3)) == 0) { $char = uc($char); }

		$new .= $char;
	}
	$line = $new;

	### exclimation marks
	if ($line !~ /^\s*$/) {
		$line .= "!";
		$line .= "!" x int(rand(3));
		if (int(rand(6)) == 0) {
			$line .= "!" x int(rand(3));
			$line .= "1" x int(rand(3));
			if (int(rand(8)) == 0) {
				$line .= "!!1ONE!";
			}
		}
	}
}

# ultra_l33t - convert the argument string to normal l33t speak.
#	this code is order dependant.
#
sub ultra_l33t {
	$line = shift;     # not my
	my ($char, $new);

	### word conversions
	$line =~ s/\broot\b/w00t/ig;
	
	### combo conversions
	$line =~ s/\bf/int(rand(2))==0?"ph":"f"/eg;

	foreach $char (split(//,$line)) {
		$char = lc($char);

		### character conversions
		if ($char eq "b" && int(rand(4)) == 0) { $char = "8"; }
		if ($char eq "c" && int(rand(6)) == 0) { $char = "("; }
		if ($char eq "d" && int(rand(6)) == 0) { $char = "|)"; }
		if ($char eq "h" && int(rand(8)) == 0) { $char = "|-|"; }
		if ($char eq "i" && int(rand(4)) == 0) { $char = "1"; }
		if ($char eq "k" && int(rand(6)) == 0) { $char = "|<"; }
		if ($char eq "m" && int(rand(8)) == 0) { $char = "/\\/\\"; }
		if ($char eq "n" && int(rand(8)) == 0) { $char = "|\\|"; }
		if ($char eq "r" && int(rand(8)) == 0) { $char = "|2"; }
		if ($char eq "v" && int(rand(8)) == 0) { $char = "\\/"; }
		if ($char eq "w" && int(rand(8)) == 0) { $char = "\\/\\/"; }
		if ($char eq "o" && int(rand(6)) == 0) { $char = "()"; }
		if ($char eq "g" && int(rand(4)) == 0) { $char = "9"; }
		if ($char eq "t" && int(rand(4)) == 0) { $char = "+"; }
		if (int(rand(2)) == 0) { $char = uc($char); }

		$new .= $char;
	}
	$line = $new;

	### exclimation marks
	if ($line !~ /^\s*$/) {
		$line .= "!" x int(rand(3));
	}
}

# usage - print a usage and exit.
#
sub usage {
	print "USAGE: l33t [-abnuv] [filename]\n";
	print "   eg,\n";
	print "      l33t /etc/release\n";
	print "      date | l33t\n\n";
	print "      l33t -a     # all\n";
	print "      l33t -b     # basic-l33t\n";
	print "      l33t -n     # normal-l33t (default)\n";
	print "      l33t -u     # ultra-l33t\n";
	print "      l33t -v     # verbose\n";
	exit 1;
}
