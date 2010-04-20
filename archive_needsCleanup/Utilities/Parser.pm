# Module for Tab::
# T. Andrew Binkowski
# Tab::Parser - Description of Object
#
# Author:
#         T. Andrew Binkowski, tabinks@hotmail.com
#
# November 2000
#

package Utilities::Parser;

use strict;
use Utilities::Text;

require Exporter;
use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&Pdb &Poc &PocInfo &Mouth &MouthInfo);

use vars       qw(%results @pdbfield $record @infofield);

sub Pdb {
    my %args = (
		INPUT        => 0,
		RECORD       => 0,
		RECORD_NAME  => 0,
		ATOM_NUMBER  => 0,
		ATOM_NAME    => 0,
		LOCATION     => 0,
		RESIDUE_NAME => 0,
		CHAIN_ID     => 0,
		RESIDUE_NUM  => 0,
		INSERT_CODE  => 0,
		POCKET_NUM   => 0,
		X_COORD      => 0,
		Y_COORD      => 0,
		Z_COORD      => 0,
		@_,
		);

         &AtomRecord($args{INPUT});
    
    if ($args{RECORD_NAME} == 1) {
	$results{RECORD_NAME} = &Tab::Text::Trim( $pdbfield[0] );
    }
    if ($args{ATOM_NUMBER} == 1) {
	$results{ATOM_NUMBER} = &Tab::Text::Trim( $pdbfield[1] );
    } 
    if ($args{ATOM_NAME} == 1) {
	$results{ATOM_NAME} = &Tab::Text::Trim( $pdbfield[3] );
    } 
    if ($args{LOCATION} == 1) {
	$results{LOCATION} = &Tab::Text::Trim( $pdbfield[4] );
    } 
    if ($args{RESIDUE_NAME} == 1) {
	$results{RESIDUE_NAME} = &Tab::Text::Trim( $pdbfield[5] );
    } 
    if ($args{CHAIN_ID} == 1) {
	$results{CHAIN_ID} = &Tab::Text::Trim( $pdbfield[7] );
    }
    if ($args{RESIDUE_NUM} == 1) {
	$results{RESIDUE_NUM} = &Tab::Text::Trim( $pdbfield[8] );
    } 
    if ($args{INSERT_CODE} == 1) {
	$results{INSERT_CODE} = &Tab::Text::Trim( $pdbfield[9] );
    }
    if ($args{POCKET_NUM} == 1) {
	$results{POCKET_NUM} = &Tab::Text::Trim( $pdbfield[10] );
    }  
    if ($args{X_COORD} == 1) {
	$results{X_COORD} = &Tab::Text::Trim( $pdbfield[11] );
    }  
    if ($args{Y_COORD} == 1) {
	$results{Y_COORD} = &Tab::Text::Trim( $pdbfield[12] );
    }  
    if ($args{Z_COORD} == 1) {
	$results{Z_COORD} = &Tab::Text::Trim( $pdbfield[13] );
    }  
    if ($args{RECORD} == 1) {
	$results{RECORD} = &Tab::Text::Trim( $pdbfield[14] );
    }

    return %results;
}

sub Poc {
# cast .poc file -- note same as PDB
    my %args = (
		INPUT        => 0,
		RECORD       => 0,
		RECORD_NAME  => 0,
		ATOM_NUMBER  => 0,
		ATOM_NAME    => 0,
		LOCATION     => 0,
		RESIDUE_NAME => 0,
		CHAIN_ID     => 0,
		RESIDUE_NUM  => 0,
		INSERT_CODE  => 0,
		POCKET_NUM   => 0,
		X_COORD      => 0,
		Y_COORD      => 0,
		Z_COORD      => 0,
		@_,
		);

         &AtomRecord($args{INPUT});
    
    if ($args{RECORD_NAME} == 1) {
	$results{RECORD_NAME} = &Tab::Text::Trim( $pdbfield[0] );
    }
    if ($args{ATOM_NUMBER} == 1) {
	$results{ATOM_NUMBER} = &Tab::Text::Trim( $pdbfield[1] );
    } 
    if ($args{ATOM_NAME} == 1) {
	$results{ATOM_NAME} = &Tab::Text::Trim( $pdbfield[3] );
    } 
    if ($args{LOCATION} == 1) {
	$results{LOCATION} = &Tab::Text::Trim( $pdbfield[4] );
    } 
    if ($args{RESIDUE_NAME} == 1) {
	$results{RESIDUE_NAME} = &Tab::Text::Trim( $pdbfield[5] );
    } 
    if ($args{CHAIN_ID} == 1) {
	$results{CHAIN_ID} = &Tab::Text::Trim( $pdbfield[7] );
    }
    if ($args{RESIDUE_NUM} == 1) {
	$results{RESIDUE_NUM} = &Tab::Text::Trim( $pdbfield[8] );
    } 
    if ($args{INSERT_CODE} == 1) {
	$results{INSERT_CODE} = &Tab::Text::Trim( $pdbfield[9] );
    }
    if ($args{POCKET_NUM} == 1) {
	$results{POCKET_NUM} = &Tab::Text::Trim( $pdbfield[10] );
    }  
    if ($args{X_COORD} == 1) {
	$results{X_COORD} = &Tab::Text::Trim( $pdbfield[11] );
    }  
    if ($args{Y_COORD} == 1) {
	$results{Y_COORD} = &Tab::Text::Trim( $pdbfield[12] );
    }  
    if ($args{Z_COORD} == 1) {
	$results{Z_COORD} = &Tab::Text::Trim( $pdbfield[13] );
    }  
    if ($args{RECORD} == 1) {
	$results{RECORD} = &Tab::Text::Trim( $pdbfield[14] );
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
        $pdbfield[10]= substr($record,67,4);  # Pocket number
        $pdbfield[11]= substr($record,31,7);  # X
        $pdbfield[12]= substr($record,39,7);  # Y
        $pdbfield[13]= substr($record,47,7);  # Z
	$pdbfield[14]= $record;               # whole record
}

sub InfoRecord {
    local($record) = pop(@_);
    $infofield[0] = $record;                #record
    $infofield[1] = substr($record, 13, 4); #id
    $infofield[2] = substr($record, 17, 4); #n_mth
    $infofield[3] = substr($record, 21, 9); #area_sa
    $infofield[4] = substr($record, 31, 9); #area_ms
    $infofield[5] = substr($record, 40, 9); #vol_sa
    $infofield[6] = substr($record, 50, 9); #vol_ms
    $infofield[7] = substr($record, 60, 7); #length
    $infofield[8] = substr($record, 68, 5); #cnr

#123456789012345678901234567890123456789012345678901234567890123456789012
#POC: /cast/m   1   0     0.910    38.42     0.039    21.06     4.86    6
#POC: Molecule ID N_mth  Area_sa  Area_ms   Vol_sa   Vol_ms    Lenth  cnr
}

sub PocInfo {
# cast .poc file -- note same as PDB
    my %args = (
		INPUT        => 0,
		RECORD       => 0,
		ID           => 0,
		AREA_SA      => 0,
		AREA_MS      => 0,
		VOL_SA       => 0,
		VOL_MS       => 0,		
		N_MOUTH      => 0,
		LENGTH       => 0,
		CNR          => 0,
		@_);

    &InfoRecord( $args{INPUT} );
    $results{RECORD}  = &Tab::Text::Trim( $infofield[0] );
    $results{ID}      = &Tab::Text::Trim( $infofield[1] );
    $results{N_MOUTH} = &Tab::Text::Trim( $infofield[2] );
    $results{AREA_SA} = &Tab::Text::Trim( $infofield[3] );
    $results{AREA_MS} = &Tab::Text::Trim( $infofield[4] );
    $results{VOL_SA}  = &Tab::Text::Trim( $infofield[5] );
    $results{VOL_MS}  = &Tab::Text::Trim( $infofield[6] );
    $results{LENGTH}  = &Tab::Text::Trim( $infofield[7] );
    $results{CNR}     = &Tab::Text::Trim( $infofield[8] );


    return %results;
}

sub MouthInfo {
    my %args = (
		INPUT        => 0,
		RECORD       => 0,
		ID           => 0,
		N_MOUTH      => 0,
		AREA_SA      => 0,
		AREA_MS      => 0,
		LENGTH_SA    => 0,
		LENGTH_MS    => 0,
		NTRI         => 0,
		@_);

    &InfoRecord( $args{INPUT} );
    $results{RECORD}     = &Tab::Text::Trim( $infofield[0] );
    $results{ID}         = &Tab::Text::Trim( $infofield[1] );
    $results{N_MOUTH}    = &Tab::Text::Trim( $infofield[2] );
    $results{AREA_SA}    = &Tab::Text::Trim( $infofield[3] );
    $results{AREA_MS}    = &Tab::Text::Trim( $infofield[4] );
    $results{LENGTH_SA}  = &Tab::Text::Trim( $infofield[5] );
    $results{LENGTH_MS}  = &Tab::Text::Trim( $infofield[6] );
    $results{NTRI}       = &Tab::Text::Trim( $infofield[7] );


    return %results;
#12345678901234567890123456789012345678901234567890123456789012345
#MTH: Molecule ID N_mth  Area_sa  Area_ms   Len_sa   Len_ms   Ntri
#MTH: /cast/m   1   0     0.000     0.00     0.000     0.00     0
}

END { } 

1;
