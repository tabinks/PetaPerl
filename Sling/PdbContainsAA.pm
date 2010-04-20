package Sling::PdbContainsAA;

use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;

sub PdbContainsAA {
    
    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";

    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_!~/^ATOM/;
	if (defined($AminoAcids{Sling::PdbParse::PdbParse_ResidueName($_)})) {
	    return 1;
	}
    }
    close FILE;
    return 0;
}

END {}
1;
