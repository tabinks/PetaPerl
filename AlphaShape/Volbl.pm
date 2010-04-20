package AlphaShape::Volbl;

use Sling::Configure;
use Sling::PdbParse;
use Utilities::Hash;
use Utilities::Trim;
use Utilities::File;

$DEBUG=1;

#############################################################
# VolblCalculationOnArray
#
#%queryVolbl = AlphaShape::Volbl::VolblCalculationOnArray("$queryPdb.$queryPocket",@queryPocketArray);
#print "$queryPdb $queryPocket\n";
#Utilities::Hash::HashPrintHashOfHash(%queryVolbl);
#############################################################
sub VolblCalculationOnArray {

    my ($PREFIX,@pdbArray) = @_;
    

    # Convert array to file
    $filePath = $CFG{'TMP'}."/volbl.$PREFIX.pdb";
    $namePath = $CFG{'TMP'}."/volbl.$PREFIX";
    $outFile = $CFG{'TMP'}."/volbl.$PREFIX.out";
    Utilities::File::FileArrayToFile($filePath,@pdbArray);
    
    `$CMD{'PDB2GALF_LINUX'} $filePath $namePath > /dev/null`;
    `$CMD{'DELCX_LINUX'} $namePath > /dev/null`;
    `$CMD{'MKALF_LINUX'} $namePath > /dev/null`;
    my $volblOut = `$CMD{'VOLBL_LINUX'} -s 1 -c 0 -p $filePath $namePath`;
    
    if ($namePath!~"up_") {
	#`rm $namePath*`;
    }
    if ($volblOut =~ /SA volume:\s+(.+)/) {
	return $1;
    } 
	
    #my %volblHash = VolblHashFromFile($namePath.".1.contrib");
    #return %volblHash;
    `rm $namePath*`;
}

###################################################################################
# ContribVolblHashLocal
#
###################################################################################
sub VolblHashFromFile {
    
    # Input/output variables
    my ($localFilePath) = @_;
    my %RETURN = ();

    if ($DEBUG) {
	print STDERR "AlphaShape::Volbl::VolblHashFromFile -File Path: $localFilePath\n";    
    }

    if (-e $localFilePath) {
	open(FILE,"<$localFilePath") or die "Contrib::ContribVolblHash::Couldn't open $localFilePath:$!";
	while (<FILE>) {
	    next if $_=~/^\#/;
	    next if $_=~/^\s+$/;
	    next if $_=~/^$/;
	    if ($_ =~ /\s+(\d+)\s+([\w\s]+)\s+(\w+)\s(\w?)\s+(\d+)\s+(\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/) {
		$atomNumber = $1;
		$atomName = $2;
		$resName = $3;
		$chain = $4;
		$resNumber = $5;
		$vert = $6;
		$sa = $7;
		$ms = $8;
		$key = Utilities::Trim::Trim($atomNumber);
		$RETURN{$key}{'SA'} = $sa;
		$RETURN{$key}{'MS'} = $ms;
		if ($DEBUG) {
		    printf("%-6d %8.3f %8.3f \n",$key,$sa,$ms);
		}
	    }
	}
	return %RETURN;
    } else {
	die "Contrib::ContribVolblHashLocal - $localFilePath does not exist\n";
    }
}

END {}
1;
