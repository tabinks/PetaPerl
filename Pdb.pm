package PetaPerl::Pdb;

use base 'Exporter';
use File::Path;

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

################################################################################
# @method    Download
# @abstract 
# @usage     
################################################################################
sub Download {
    my($PDB,$PATH) = @_;
    $PDB=lc($PDB);
    $PATH=($PATH)?$PATH:"./";
    # 
    my $PDBDIR = substr($PDB,1,2);
    mkpath("$PATH/PDB/$PDBDIR/");
    $ftpFilePath = "ftp://ftp.wwpdb.org/pub/pdb/data/structures/divided/pdb/$PDBDIR/pdb$PDB.ent.gz";
    $localFilePath =  "$PATH/PDB/$PDBDIR/$PDB.pdb.gz";
    `wget -nc -q -O $localFilePath $ftpFilePath`;
    system("gunzip $localFilePath");
    return $PATH;
}

sub ChainExtract {
    my ($CHAIN,$PATH) = @_;
    my @return_array=();
    open(PDB,"<$PATH") or die "Couldn't open $PATH";
    while(<PDB>) {
        if ($CHAIN eq substr($_,21,1)) {
	    push @return_array,$_;
	}
    }
    return @return_array;
}
sub Chains {
    
}

END {}
1;
