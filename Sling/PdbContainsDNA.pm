package Sling::PdbContainsDNA;

use Sling::Configure;
use Sling::PdbParse;

sub PdbContainsDNA {
    
    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    
    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_!~/^ATOM/;
	$chain = Sling::PdbParse::PdbParse_Chain($_);
	$residue_name = Sling::PdbParse::PdbParse_ResidueName($_);
	$residue_number = Sling::PdbParse::PdbParse_ResidueNumber($_);
	$key = $residue_name."_". $residue_number."_". $chain;    
	
	if ($residue_name eq 'A' || $residue_name eq 'T' ||
	    $residue_name eq 'C' || $residue_name eq '+C' || 
	    $residue_name eq 'G' || $residue_name eq 'U' ||  
	    $residue_name eq '+U' ) {
	    close FILE;
	    return 1;
	}
    }
    close FILE;
    return 0;
}

END {}
1;
