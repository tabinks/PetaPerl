package Sling::DirectorySingle;

use Sling::Configure;
use Sling::PdbParse;
use Sling::GpssFileTests;

sub DirectorySingle {
    
    my ($PDB,$dir) = @_;
    my @return;

    $path = $CFG{'LOCAL_CAST'}.'/'.substr($PDB,1,2);
    $path = $dir.'/'.substr($PDB,1,2);
    
    opendir(DIR, $path) or die "can't opendir $path: $!";
    while (defined($pdbfile = readdir(DIR))) {
	next unless $pdbfile =~ /^($PDB\.?[0-9A-Z]?)\.pdb/;
	if (Sling::GpssFileTests::castpFilesExist($1)) {
	    push @return, $1;
	}
    }
    closedir(PDBDIR);
    
    return @return;
}


END {}
1;
