#!/usr/bin/perl
#
# onstat - Server on status.
#
#Description: This program tells you if your server is switched on
#  A common problem
#  is when staff attempt to use a server or desktop when the power is not
#  switched on. This may help diagnose such a situation.
#
# 08-Nov-2004	ver 1.00
#
# USAGE: onstat
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
# 08-Nov-2004	Brendan Gregg	Created this.

# We check if the server is on by asking the ALU to perform an operation,
$result = 1 + 1;

if ($result == 2) {
	print "Server is ON.\n";
} else {
	print "Server is OFF.\n";
	print "Power on the system before attempting to run any programs!\n";
}

