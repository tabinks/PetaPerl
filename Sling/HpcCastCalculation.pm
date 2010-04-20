package Sling::HpcCastCalculation;

use Sling::Configure;
use Sling::PdbParse;
use Sling::PdbFixNMR;
use Sling::Array;

sub HpcCastCalculation {
    
    my ($PREFIX) = @_;
    ($PDB,$LIGAND, $LIGAND_NUMBER, $CHAIN) = split /\s+/,$PREFIX;
    
    my $HPC_PATH =  $CFG{'LOCAL_HPC'}.'/'.substr($PDB,1,2).'/';
    
    #if (-s "$HPC_PATH/$PREFIX.lpc.poc" && !-s "$HPC_PATH/$PREFIX.pocInfo") {
    if (-s "$HPC_PATH/$PREFIX.lpc.poc") {
	`cp $HPC_PATH/$PREFIX.lpc.poc $HPC_PATH/$PREFIX.pdb`;
	`perl /home/tbinkowski/projects/slingManage/castp/CASTp_distribution_SGI/CASTp -pdb $HPC_PATH/$PREFIX.pdb`;
    }
}

END {}
1;
