package Sling::SurfaceComposition;

use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;
use Sling::PdbContainsAA;
use Sling::Array;
use Sling::Hash;
use File::Basename;

################################################################
# SurfaceComposition()
#    
################################################################
sub SurfaceComposition {

    my ($PDB,$POCKET,$DIRECTORY) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{$DIRECTORY}."/$PDBDIR/$PDB.poc";
    
    my @return_array = ();    
    my @return_unique = ();

    my %compositionHash = ();
    my %compositionHash = ("ALA"=>0,"ARG"=>0,"ASN"=>0,"ASP"=>0,
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

###################################################################################
# SurfaceCompositionWithFilePath
#
###################################################################################
sub SurfaceCompositionWithFilePath {

    my ($FILEPATH) = @_;

    my @return_array = ();    
    my @return_unique = ();
    my %compositionHash = ();
    my %compositionHash = ("ALA"=>0,"ARG"=>0,"ASN"=>0,"ASP"=>0,
			   "CYS"=>0,"GLN"=>0,"GLU"=>0,"GLY"=>0,
			   "HIS"=>0,"ILE"=>0,"LEU"=>0,"LYS"=>0,
			   "MET"=>0,"PHE"=>0,"PRO"=>0,"SER"=>0,
			   "THR"=>0,"TRP"=>0,"TYR"=>0,"VAL"=>0);

    if (Sling::PdbContainsAA::PdbContainsAA(substr(basename($FILEPATH),0,4))) {
	open (FILE,"< $FILEPATH") or die "Couldn't open $FILEPATH\n";    
	while (<FILE>) {
	    next if $_=~/^$/;
	    next if $_!~/^ATOM/;
	    $residueName = Sling::PdbParse::PdbParse_ResidueName($_);
	    $chain = Sling::PdbParse::PdbParse_Chain($_);
	    $residue_number = Sling::PdbParse::PdbParse_ResidueNumber($_);
	    $key = $chain."_".$residue_number."_$residueName";
	    push @return_array, $key;
	}
	close FILE;
	@return_unique = Sling::Array::ArrayUnique(@return_array);
	
	foreach (@return_unique) { 
	    ($chain,$residueNumber,$residueName) = split /_/;
	    $compositionHash{$residueName}++;
	}
	return %compositionHash;
    }
}

###################################################################################
# SurfaceCompositionWithFilePathAndPocket
#
###################################################################################
sub SurfaceCompositionWithFilePathAndPocket {

    my ($FILEPATH,$POCKET) = @_;

    my @return_array = ();    
    my @return_unique = ();
    my %compositionHash = ();
    my %compositionHash = ("ALA"=>0,"ARG"=>0,"ASN"=>0,"ASP"=>0,
			   "CYS"=>0,"GLN"=>0,"GLU"=>0,"GLY"=>0,
			   "HIS"=>0,"ILE"=>0,"LEU"=>0,"LYS"=>0,
			   "MET"=>0,"PHE"=>0,"PRO"=>0,"SER"=>0,
			   "THR"=>0,"TRP"=>0,"TYR"=>0,"VAL"=>0);

    if (Sling::PdbContainsAA::PdbContainsAA(substr(basename($FILEPATH),0,4))) {
	open (FILE,"< $FILEPATH") or die "Couldn't open $FILEPATH\n";    
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
	    ($chain,$residueNumber,$residueName) = split /_/;
	    $compositionHash{$residueName}++;
	}
	return %compositionHash;
    }
}

END {}
1;
