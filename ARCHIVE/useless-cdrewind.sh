#!/usr/bin/perl
#
# cdrewind
#Description: Rewind CDROMs before ejection. Perl, Unix.
#
# Many Unix based operating systems neglect to rewind CDROMs fully
#  before ejection. This may leave some CDROMs positioned incorrectly 
#  when they are next used. cdrewind should be used to ensure that 
#  the CDROM drive has completed the rewind cycle before the disk
#  is removed.
#
# Some cheaper CDROM drives can eject the disk while there are still
#  tracks in the drive. Placing these tracks back on the CDROM is a
#  tedious process, only slightly improved when using a quality
#  pair of CDROM tweezers. Some admins and found that spraying their
#  CDROMs with shaving cream can help keep the tracks on the CDROM.
#  cdrewind is far more reliable and should be used for desktops
#  through to servers.
#
# 26-Feb-2005	ver 1.00
#
# USAGE: cdrewind [-v] path-to-special
#    eg,
#        cdrewind -v /vol/dev/aliases/cdrom0     # Solaris
#        cdrewind -v /dev/dsk/c0t2d0s2           # Solaris, no vold
#
#
# SEE ALSO: dvdrewind
#
# COPYRIGHT: Copyright (c) 2004 Brendan Gregg.
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
# 26-Feb-2005	Brendan Gregg	Created this.


#
#  Process Command Line Arguments
#
use Getopt::Std;
getopts('v') || &usage();
$verbose = $opt_v;
$pathname = $ARGV[0];
&usage() if $pathname eq "";


#
#  Rewind CDROM
#
open(CDROM,$pathname) || die("ERROR1: Can't access $pathname: $!\n");
$read = read(CDROM,$buf,1);	# test CDROM
$seek = seek(CDROM,0,0);	# rewind
close(CDROM);

if ($read && $seek) {
	print "CDROM rewound successfully.\n" if $verbose;
	exit(0);
} else {
	print "CDROM rewind failed.\n" if $verbose;
	exit(1);
}


#
#  Subroutines
#
sub usage {
	print STDERR "USAGE: cdrewind [-v] path-to-special\n";
	print STDERR "   eg,\n";
	print STDERR "       cdrewind /vol/dev/aliases/cdrom0     # Solaris\n";
	print STDERR "       cdrewind /dev/dsk/c0t2d0s2           # Solaris, no vold\n";
	exit(1);
}
