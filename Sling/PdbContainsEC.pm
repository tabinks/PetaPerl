package Sling::PdbContainsEC;

use Sling::Configure;
use Sling::PdbParse;
use Sling::Array;;

sub PdbContainsEC {
    
    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
   
    my @return = ();
    my @return_unique = ();
    
    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_=~/^ATOM|^HETATM|^CONECT|^MASTER|^END|^TER|ORIG|^SCALE|^SHEET|^HELIX|^SEQRES/;
	if ($_=~/E\.C\.(\d\.\d+\.\d+\.\d+)/) {
	    push @return, $1;
	}
	if ($_=~/EC:\s+(\d\.\d+\.\d+\.\d+)/) {
	    push @return, $1;
	}
    }
    close FILE;

    @return_unique = Utilities::Array::ArrayUnique(@return);
    return @return_unique;
}

END {}
1;
