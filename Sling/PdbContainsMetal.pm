package Sling::PdbContainsMetal;

use Sling::Configure;
use Sling::PdbParse;
use Sling::Metals;

sub PdbContainsMetal {
    
    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    
    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_!~/^HETATM/;
	if (defined($Metals{Sling::PdbParse::PdbParse_ResidueName($_)})) {
	    return 1;
	}
    }
    close FILE;
    return 0;
}

END {}
1;
