################################################
# atom2pocket.pl
#
# Author: T.A. Binkowski
# Date:   6/10/02
# 
# This script takes a pdb name and atom number
# number and returns the pocket(s) where it is
#
# Usage: residue2pocket.pl 1mbn 0 101
################################################

package Tab::Cast;
require Exporter;

use lib "/home/abinkowski/lib";
use Tab::Parser; 
use Tab::Array;

$VERSION = 0.01;

sub residue2pocket {
# given a residue number and chain id
# optionally takes the atom name (should
# take the atom number......)
# return array of pocket numbers

    my ($pdb,$chain_cmd,$residue,$atom_name) = @_;
    my $dir       = substr($pdb,1,2);
    my $cast_dir  = "/cast/";
    my $file      = "$cast_dir/$dir/$pdb.poc";

    my %results   = (); # for parse.pm
    my @pockets   = ();
    my @line      = (); # line of .lig file

    # Fix chain id
    if ($chain_cmd eq "O") {
	$chain = "";
    } else {
	$chain = $chain_cmd;
    }

    # Check and open poc file
    if (-e "$file") {
	open (POC, "< $file") 
	    or die "Couldn't open $file $!\n";
    } else {
	die "$file doesn't exist\n";
    }
    
    # Search 
    while (<POC>) {
	next if $_ =~ /^\#/;
	chomp $_;
	my %results = &Tab::Parser::Poc(
					INPUT        => $_, RESIDUE_NAME => 1,
					CHAIN_ID     => 1,  RESIDUE_NUM  => 1,
					POCKET_NUM   => 1,  ATOM_NAME    => 1
					);
	if (defined( $atom_name )) {
	    if ($results{RESIDUE_NUM} eq $residue && $results{CHAIN_ID} eq $chain &&
		$results{ATOM_NAME} eq $atom_name) {
		push @pockets, $results{POCKET_NUM};
	    }
	} else {
	    if ($results{RESIDUE_NUM} eq $residue && $results{CHAIN_ID} eq $chain) {
		push @pockets, $results{POCKET_NUM};
	    }
	}
	}
	close POC;     
	
        # Return to program
	return &Tab::Array::array_unique( @pockets );
    }


END {}
1;











