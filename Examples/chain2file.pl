#!/usr/bin/perl                                                                                                         
################################################################################
#
#
#
################################################################################
# List the resolution of each gpss structure
#
#
################################################################################

use File::Path;
use File::Spec::Functions qw(rel2abs);
use File::Basename;
use Getopt::Long;

use lib $ENV{'PETAPERL_LIBRARY'};
use lib $ENV{'SLING_LIBRARY'};

use PetaPerl::Environment;
use PetaPerl::Log;
use PetaPerl::Pdb;
use Sling::Configure;

use Sling::PdbChains;
GetOptions("pdb=s"       => \$PDB,
	   "chain=s"     => \$CHAIN,
	   "path=s"      => \$PATH,
	   "prefix=s" => \$PREFIX);

PetaPerl::Log::About(NULL,@ARGV);

&Sling::PdbChains::PdbChainToFile($PDB,$CHAIN,$PATH,$PREFIX);


#foreach(&Sling::PdbChains::PdbChainsLength($ARGV[0])) {
#    print $_;
#}
    
if($z) {
open(DB,"<$ARGV[0]");
while(<DB>) {
    $orig=$_;
    $_=~s/Gpss/cast/;
    $path = substr($_,0,50).".pdb";
    $pdb=substr(basename($path),0,4);
    print "$pdb ".PetaPerl::Pdb::Resolution($path)." $orig";
}
}
