#
# Module for Tab::
# T. Andrew Binkowski
#
#

# POD documentation
=head1 NAME

Tab::Parser - Description of Object

=head1 NAME

Tab::Parser - Description of Object

=head1 SYNOPSIS

    %results = $Tab::Parser::Pdb(
				 INPUT        => 0,
				 RECORD_NAME  => 0,
				 ATOM_NUMBER  => 0,
				 ATOM_NAME    => 0,
				 LOCATION     => 0,
				 RESIDUE_NAME => 0,
				 CHAIN_ID     => 0,
				 RESIDUE_NUM  => 0,
				 INSERT_CODE  => 0,
				 POCKET_NUM   => 0, 
				 );

     print "$results{RECORD_NAME}\n";

=head1 DESCRIPTION

Parser is an object that will parse a line of a pdb formated file and
return a hash of the fields you specify.  


=head1 INSTALLATION

This module is included with the Tab:: distribution.

=head1 AUTHOR

T. Andrew Binkowski, tabinks@hotmail.com

=cut

# The code ...

package Tab::Parser;

use strict;

require Exporter;
use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&Pdb &AtomRecord);

use vars       qw(%results @pdbfield $record);

sub Pdb {
    my %args = (
		INPUT        => 0,
		RECORD_NAME  => 0,
		ATOM_NUMBER  => 0,
		ATOM_NAME    => 0,
		LOCATION     => 0,
		RESIDUE_NAME => 0,
		CHAIN_ID     => 0,
		RESIDUE_NUM  => 0,
		INSERT_CODE  => 0,
		POCKET_NUM   => 0,
		@_,
		);

    &AtomRecord($args{INPUT});
    
    if ($args{RECORD_NAME} == 1) {
	$results{RECORD_NAME} = $pdbfield[0];
    }
    if ($args{ATOM_NUMBER} == 1) {
	$results{ATOM_NUMBER} = $pdbfield[1];
    } 
    if ($args{ATOM_NAME} == 1) {
	$results{ATOM_NAME} = $pdbfield[3];
    } 
    if ($args{LOCATION} == 1) {
	$results{LOCATION} = $pdbfield[4];
    } 
   if ($args{RESIDUE_NAME} == 1) {
	$results{RESIDUE_NAME} = $pdbfield[5];
    } 
    if ($args{CHAIN_ID} == 1) {
	$results{CHAIN_ID} = $pdbfield[7];
    }
    if ($args{RESIDUE_NUM} == 1) {
	$results{RESIDUE_NUM} = $pdbfield[8];
    } 
    if ($args{INSERT_CODE} == 1) {
	$results{INSERT_CODE} = $pdbfield[9];
    }
    if ($args{POCKET_NUM} == 1) {
	$results{POCKET_NUM} = $pdbfield[10];
    }  

    return %results;
}
		

sub AtomRecord  {
        local($record) = pop(@_);
        $pdbfield[0] = substr($record,0,6);   # Record Name
        $pdbfield[1] = substr($record,6,5);   # Atom number
        $pdbfield[2] = substr($record,11,1);  #
        $pdbfield[3] = substr($record,12,4);  # Atom name
        $pdbfield[4] = substr($record,16,1);  # Location indicator
        $pdbfield[5] = substr($record,17,3);  # Residue Name
        $pdbfield[6] = substr($record,20,1);  #
        $pdbfield[7] = substr($record,21,1);  # Chain ID
        $pdbfield[8] = substr($record,22,4);  # Residue Number 
        $pdbfield[9] = substr($record,26,1);  # Insertion Code
        $pdbfield[10]= substr($record,67,3);  # Pocket number
}

END { } 

1;
