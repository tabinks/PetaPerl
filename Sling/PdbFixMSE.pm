package Sling::PdbFixMSE;

use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;
use Sling::PdbContainsAA;

################################################################
# PdbFixMSE
#
################################################################
sub PdbFixMSE {
    
    my @ORIG_PDB = ();    

    foreach (@_) {
	$line = $_;
	if (Sling::PdbParse::PdbParse_ResidueName($line) eq "MSE") {
	    substr($line,0,6) = "ATOM  ";
	    substr($line,17,3) = "MET";
	    if (Sling::PdbParse::PdbParse_AtomName($line) eq "SE") {
		substr($line,12,4) = " SD ";
	    }
	}
	push @ORIG_PDB, $line;
    }
    return @ORIG_PDB;
}

END {}
1;
