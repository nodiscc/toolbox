#!/usr/bin/perl -w
#Convert VCF address book files to CSV
#Source: http://people.ofset.org/~ckhung/p/vcf2csv/vcf2csv
#Works with owncloud VCF files

use Getopt::Std;
use strict;

use vars qw(%opts $Pack %Card %AllKeys $line);

%opts = (
    d => ",",	# delimiter
);

getopts('d:', \%opts);

$line = <>;
while (1) {
    my ($s1, $s2, $encoded, $s4);
    $line =~ s/\015//;
    chomp $line;
    if ($line =~ /^PHOTO;/) {
	while (<>) {
	    last if /^[A-Z]/;
	}
	# skip photos
	$line = $_;
    } else {
	store($line);
	last unless defined ($line = <>);
    }
}

my (@keys, $i, $k);
@keys = sort keys %AllKeys;
print join($opts{d}, @keys), "\n";
for ($i=0; $i<=$#$Pack; ++$i) {
    foreach $k (@keys) {
	$Pack->[$i]{$k} = "" unless defined $Pack->[$i]{$k};
    }
    print join($opts{d}, @{$Pack->[$i]}{@keys}), "\n";
}

sub store {
    my ($prop) = @_;
    if ($prop =~ /BEGIN:VCARD/) {
	# skip
    } elsif ($prop =~ /END:VCARD/) {
	my (%c) = %Card;
	my (@keys) = keys %Card;
	@AllKeys{@keys} = (1) x ($#keys + 1);
	push @$Pack, \%c;
	%Card = ();
    } else {
	my ($k, $v) = split ':', $prop;
	$Card{$k} = $v;
    }
}


