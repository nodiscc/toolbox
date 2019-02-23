#!/usr/bin/perl -w

use Getopt::Std;
use strict;

use vars qw(@Keys %opts);

%opts = (
    d => ",",	# delimiter
);

getopts('d:', \%opts);

my ($k, $i);
$k = <>;
$k =~ s/\015//;
chomp $k;
@Keys = split /$opts{d}/, $k;
while (<>) {
    s/\015//;
    chomp;
    my (@v) = split /$opts{d}/;
    next unless $#v >= 1;
    if ($#v < 1) {
	printf STDERR "Warning: skipping line $.\n";
	next;
    }
    print "BEGIN:VCARD\n";
    for ($i=0; $i<=$#v; ++$i) {
	print "$Keys[$i]:$v[$i]\n" if $v[$i];
    }
    print "END:VCARD\n";
}

