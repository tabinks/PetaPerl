package PetaPerl::Pdb;

use base 'Exporter';

our @EXPORT    = qw(Resolution);
#our $_PETADOCK_HOME="/home/abinkows/bin/PetaDock/";

########################################################
# Resolution
#
########################################################
sub Resolution {
    my($PDBFILE)=@_;
    die("$PDBFILE doesn't exist") if !-e $PDBFILE;
    open(FILE,"<$PDBFILE");
    while(<FILE>) {
	if($_=~/REMARK\s+2\s+RESOLUTION\.\s+(\d+\.\d+)/) {
	    $resolution=$1;
	    last;
	}
    }
    close FILE;
    return $resolution;
}

END {}
1;
