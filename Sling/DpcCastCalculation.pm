package Sling::DpcCastCalculation;

use Sling::Configure;
use Sling::PdbParse;
use Sling::PdbFixNMR;
use Sling::Array;

sub DpcCastCalculation {
    
    my ($PDB) = @_;    
    my $DPC_PATH =  $CFG{'LOCAL_DPC'}.'/'.substr($PDB,1,2).'/'; 

    $PREFIX = "$PDB.dpc";
    if (-s "$DPC_PATH/$PDB.dna.poc" && !-s "$DPC_PATH/$PREFIX.pocInfo") {
	`cp $DPC_PATH/$PDB.dna.poc $DPC_PATH/$PREFIX.pdb`;
	`perl /home/tbinkowski/projects/slingManage/CastP/CASTp_distribution_SGI/CASTp -pdb $DPC_PATH/$PREFIX.pdb`;
    }
}

END {}
1;
