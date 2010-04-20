package Sling::PocketLoad;

use Sling::Configure;

sub PocketLoad {

    my ($PDB,$DIR) = @_;
    my @return = ();
    
    if (!$DIR) {
	$DIR = 'LOCAL_CAST';
    }

    $path = $CFG{$DIR}.'/'.substr($PDB,1,2).'/'.$PDB.'.poc';
    open(PDB,"< $path") or
	die "Couldn't open $path:$!\n";
    @return = (<PDB>);
    close PDB;

    return @return;
}
        


END {}
1;
