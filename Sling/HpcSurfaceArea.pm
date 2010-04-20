package Sling::HpcSurfaceArea;

use File::Path;
use File::stat;
use Env;
use Sling::Configure;
use Sling::AminoAcids;
use Sling::PdbParse;
use Sling::PdbContainsAA;
use Sling::PdbFixNMR;
use Sling::PdbStripDNA;
use Sling::DirectoryRecursive;
use Sling::Trim;
use Sling::XtalArtifacts;
use Sling::Metals;
use Sling::HpcMmcifHash;
use Sling::PdbGetHet;
use Sling::Date;
use Sling::HpcCastCalculation;
use Sling::Contrib;
use Sling::File;
use Sling::PdbLineByAtom;

sub HpcSurfaceArea {

    my ($PDB,$SURFACE_ID) = (@_);
    my $saSum = 0.0;
    my $msSum = 0.0;
    %return = {};

    print STDERR "Sling::HpcSurfaceArea::HpcSurfaceArea()\n";

    my %lookup = Sling::Contrib::ContribVolblHash($PDB);
    #Sling::Hash::HashPrint(%lookup);

    my $path =  $CFG{'LOCAL_HPC'}.'/'.substr($PDB,1,2).'/'; 
    my $pocFile = $path."/".$SURFACE_ID.".lpc.poc";
    
    open(FILE,"<$pocFile") or die "pocfile: Couldn't open $pocFile:$!";
    while (<FILE>) {
	next if $_!~/^ATOM/;
	$atomNumber = Sling::PdbParse::PdbParse_AtomNumber($_);
	$saSum += $lookup{$atomNumber}{'SA'};
	$msSum += $lookup{$atomNumber}{'MS'};
	#printf("%-6d %8.4f %8.4f - %8.4f %8.4f - %s",$atomNumber,$lookup{$atomNumber}{'SA'},$lookup{$atomNumber}{'MS'},$saSum,$msSum,$_);
    }
    close(FILE);
    $return{'SA'} = $saSum;
    $return{'MS'} = $msSum;

    return %return;
}



END {}
1;
