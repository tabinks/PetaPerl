package Sling::PdbFixNMR;

use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;
use Sling::PdbContainsAA;
use Sling::File;

################################################################
# PdbFixNMR
#    
#
################################################################
sub PdbFixNMR {

    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    
    my @return_array = ();    
    my @ORIG_PDB = ();
    
    print STDERR "Sling::PdbFixNMR - Enter\n";
    #######################################################
    # Slurp the file into array
    #######################################################
    if (!-e $PDBPATH) {
	die("Sling::PdbFixNMR::PdbFixNMR - $PDBPATH not found\n");
    }
    
    @ORIG_PDB = Sling::File::FileToArray($PDBPATH);
    if (Sling::PdbFixNMR::_PdbContainsNMR($PDB)) {
	for($z=0;$z<$#ORIG_PDB;$z++) {
	    if ($ORIG_PDB[$z]=~/MODEL +2/) {
		$z=$#ORIG_PDB;
	    } else {
		push @return_array, $ORIG_PDB[$z];
	    }
	}
	print "Sling::PdbFixNMR - Returning new array\n";
	return @return_array;
    } else {
	print "Sling::PdbFixNMR - Returning original array\n";
	return @ORIG_PDB;
    }
}

################################################################
# _PdbContainsNMR
#    Determine if the pdb file has the string MODEL 2
#
################################################################
sub _PdbContainsNMR {
    
    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    my $FOUND = 0;
    
    ############################################################
    # Load orignal file into array
    ############################################################
    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    my @ORIG_PDB=(<FILE>);
    close FILE;

    ############################################################
    # Load orignal file into array
    ############################################################
    for($z=0;$z<$#ORIG_PDB;$z++) {
	if ($ORIG_PDB[$z]=~/^MODEL +2/) {
	    $z=$#ORIG_PDB;
	    $FOUND = 1;
	}
    }
    return $FOUND;
}

END {}
1;
