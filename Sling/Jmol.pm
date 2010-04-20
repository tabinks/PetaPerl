package Sling::Jmol;

use Sling::Configure;
use Sling::PdbParse;

################################################################
# pocketAtomCount
# 
# Created: January 16, 2006
################################################################
sub jmolSurfaceSelectString {
    
    my ($PDB,$POCKET,$DIRECTORY) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{$DIRECTORY}."/$PDBDIR/$PDB.poc";
    
    $jmolSurfaceSelectString = "$select ";
    
    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_=~/^$/;
	next if $_!~/^ATOM/;
	if (Sling::PdbParse::PdbParse_Pocket($_) == $POCKET) {
	    $jmolSurfaceSelectString .= "atomno=".Sling::PdbParse::PdbParse_AtomNumber($_).",";
	}
    }
    close FILE;
    return substr($jmolSurfaceSelectString,0,-1);
}

END {}
1;
