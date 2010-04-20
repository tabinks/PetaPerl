package Sling::PdbStripChain;

use Sling::Configure;
use Sling::PdbParse;

sub PdbStripChain {
    
    my ($CHAIN,@PDB) = @_;
    my @return_array=();

    foreach (@PDB) {
	if ($_=~/^ATOM/ && $CHAIN ne Sling::PdbParse::PdbParse_Chain($_)) {
	    push @return_array,$_;
	}
    }
    return @return_array;
}

END {}
1;
