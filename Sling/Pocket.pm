package Sling::Pocket;

use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;
use Sling::PdbContainsAA;
use Sling::Array;
use Sling::Hash;

################################################################
# Pocket Length ()
#    
################################################################
sub PocketLength {

    my ($PDB,$POCKET,$DIRECTORY) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{$DIRECTORY}."/$PDBDIR/$PDB.poc";
    
    my @return_array = ();    
    my @return_unique = ();

    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_=~/^$/;
	next if $_!~/^ATOM/;
	if (Sling::PdbParse::PdbParse_Pocket($_) == $POCKET) {
	    $chain = Sling::PdbParse::PdbParse_Chain($_);
	    $residue_number = Sling::PdbParse::PdbParse_ResidueNumber($_);
	    $key = $chain."_".$residue_number;
	    push @return_array, $key;
	}
    }
    close FILE;
    @return_unique = Sling::Array::ArrayUnique(@return_array);
    return $#return_unique+1;
}

################################################################
# Pocket Length ()
#    
################################################################
sub pocketResidueComposition {

    my ($PDB,$POCKET,$DIRECTORY) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{$DIRECTORY}."/$PDBDIR/$PDB.poc";
    
    my @return_array = ();    
    my @return_unique = ();

    my %compositionHash = ();
    my %compositionHash = ('ALA'=>0,"ARG"=>0,"ASN"=>0,"ASP"=>0,
			   "CYS"=>0,"GLN"=>0,"GLU"=>0,"GLY"=>0,
			   "HIS"=>0,"ILE"=>0,"LEU"=>0,"LYS"=>0,
			   "MET"=>0,"PHE"=>0,"PRO"=>0,"SER"=>0,
			   "THR"=>0,"TRP"=>0,"TYR"=>0,"VAL"=>0);

    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_=~/^$/;
	next if $_!~/^ATOM/;
	if (Sling::PdbParse::PdbParse_Pocket($_) == $POCKET) {
	    $residueName = Sling::PdbParse::PdbParse_ResidueName($_);
	    $chain = Sling::PdbParse::PdbParse_Chain($_);
	    $residue_number = Sling::PdbParse::PdbParse_ResidueNumber($_);
	    $key = $chain."_".$residue_number."_$residueName";
	    push @return_array, $key;
	}
    }
    close FILE;
    @return_unique = Sling::Array::ArrayUnique(@return_array);

    foreach (@return_unique) { 
	#print "$_ ";
	($chain,$residueNumber,$residueName) = split /_/;
	$compositionHash{$residueName}++;
    }
    #Sling::Hash::HashPrint(%compositionHash);
    return %compositionHash;
}

################################################################
# pocketAtomCount
# 
# Created: January 16, 2006
################################################################
sub pocketAtomCount {

    my ($PDB,$POCKET,$DIRECTORY) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{$DIRECTORY}."/$PDBDIR/$PDB.poc";
    
    $atomCount=0;

    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_=~/^$/;
	next if $_!~/^ATOM/;
	if (Sling::PdbParse::PdbParse_Pocket($_) == $POCKET) {
	    $atomCount++;
	}
    }
    close FILE;
    return $atomCount;
}

################################################################
# Pocket Chains ()
#    
################################################################
sub PocketChains {
    
    my ($PDB,$POCKET,$DIRECTORY) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{$DIRECTORY}."/$PDBDIR/$PDB.poc";
    
    my @return_array = ();    
    
    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_=~/^$/;
	if (Sling::PdbParse::PdbParse_Pocket($_) == $POCKET) {
	    push @return_array, Sling::PdbParse::PdbParse_Chain($_);
	}
    }
    close FILE;
    return Sling::Array::ArrayUnique(@return_array);
}

###############################################################
# PocketChainsPretty
#
# Author: T. Andrew Binkowski
# Date: 4/15/2005
#
# Descriptions: Return chains in format of i(AB) if at interface
###############################################################
sub PocketChainsPretty {

    my ($PDB,$POCKET,$DIRECTORY) = @_;
    my $string = "";
    
    @pchains = Sling::Pocket::PocketChains($PDB,$POCKET,$DIRECTORY);
    if ($#pchains>0) {
	$string = "i(";
	foreach (@pchains) {
	    $string .= $_;
	}
	$string .= ")";
    } else {
	$string = $pchains[0];
    }
    
    return $string;
}

END {}
1;
