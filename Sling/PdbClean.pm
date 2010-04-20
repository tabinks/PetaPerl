package Sling::PdbClean;

use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;
use Sling::PdbContainsAA;
use Sling::PdbFixNMR;
use Sling::PdbStripDNA;
use Sling::PdbFixMSE;
use Sling::File;

################################################################
# PdbClean
#    
#
################################################################
sub PdbClean {

    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    
    my @return_array = ();    
    my @ORIG_PDB = ();
    
    print STDERR "Sling::PdbClean::PdbClean \n";
    if (!-e $PDBPATH) {
	die("Sling::PdbClean::PdbClean - $PDBPATH not found\n");
    }
    
    @nmrClean = Sling::PdbFixNMR::PdbFixNMR($PDB);
    @dnaClean = Sling::PdbStripDNA::PdbStripDNA(@nmrClean);
    @mseClean = Sling::PdbFixMSE::PdbFixMSE(@dnaClean);
    print STDERR "Sling::PdbClean::PdbClean - Done \n";
    return @mseClean;
}

END {}
1;
