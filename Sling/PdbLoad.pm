package Sling::PdbLoad;
use lib '/home/tbinkowski/lib';
use Utilities::File;
use Sling::Configure;

#################################################################################
# PdbFileToArray
#
#################################################################################
sub PdbFileToArray {

    my ($PDB) = @_;
    return Utilities::File::FileToArray($CFG{'LOCAL_CAST'}.'/'.substr($PDB,1,2).'/'.$PDB.'.pdb');
}

# Old
sub PdbLoad {

    my ($PDB) = @_;
    my @return = ();
    
    $path = $CFG{'LOCAL_CAST'}.'/'.substr($PDB,1,2).'/'.$PDB.'.pdb';
    open(PDB,"< $path") or
	die "Couldn't open $path:$!\n";
    @return = (<PDB>);
    close PDB;

    return @return;
}
        


END {}
1;
