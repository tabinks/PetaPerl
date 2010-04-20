package Sling::SlingBundle;

use Sling::Configure;
use Sling::PdbChains;

sub slingPdbExists {
    my ($PDB) = @_;

    $file = $CFG{'LOCAL_CAST'}.'/'.substr($PDB,1,2).'/'.$PDB;
    return (-e "$file.pdb") ? 1 : 0;
}


sub slingBundleExists {
    
    my ($PDB) = @_;

    $file = $CFG{'LOCAL_CAST'}.'/'.substr($PDB,1,2).'/'.$PDB;

    # Check if basic files are all there
    if (!-e "$file.pdb" ||
	!-e "$file.poc" || 
	!-e "$file.pocInfo" || 
	!-e "$file.mouth" || 
	!-e "$file.mouthInfo") {
	return 0;
    } 
	
    # Check if all chain files are there
    @chains = Sling::PdbChains::PdbChains($PDB);
    foreach $chain (@chains) {
	print STDERR "$file.$chain.*\n";
	if (!-e "$file.$chain.pdb" || 
	    !-e "$file.$chain.poc" ||
	    !-e "$file.$chain.pocInfo" ||
	    !-e "$file.$chain.mouth" || 
	    !-e "$file.$chain.mouthInfo") {
	    return 0;
	}
    }
    return 1;
}

END {}
1;
