package Sling::Contrib;

use File::Path;
use Sling::Configure;
use Sling::PdbParse;
use Sling::Array;
use Sling::Configure;
use Sling::AminoAcids;
use Sling::PdbParse;
use Sling::PdbContainsAA;
use Sling::PdbClean;
use Sling::PdbLoad;
use Sling::Date;
use Sling::PdbStripChain;
use lib '/home/tbinkowski/lib/';
use Utilities::Hash;
use Utilities::Trim;

##########################################################################
#
#
# Sling::Contrib::ContribVolbl('pdbId',''); uses a pdb file in CAST db
# Sling::Contrib::ContribVolbl('','localfile'); uses a local file
##########################################################################
sub ContribVolbl {
    
    # Input/output variables
    my ($PDB) = @_;
    my @CLEANPDB = ();
    my %RETURN = {};
    print STDERR "Sling::ContribVolbl:: PDB=$PDB\n";
    
    # Input/output file paths
    my $CONTRIB_PATH = $CFG{'LOCAL_CONTRIB'}."/".substr($PDB,1,2);
    mkpath($CONTRIB_PATH);
    my $pdb_file        = "$CONTRIB_PATH/$PDB.clean.pdb";
    my $pdb_orig_file   = "$CAST_DIR/$PDB_DIR/$PDB.pdb";
    my $poc_file        = "$CONTRIB_PATH/$PDB.cleanpoc";
    my $p_name          = "$CONTRIB_PATH/$PDB.clean";
    my $p_out           = "$CONTRIB_PATH/$PDB.clean.output";
    my $pdbCleanContrib = "$CONTRIB_PATH/$PDB.1.contrib";

    # Architecture check
    if ($ENV{'ARCH'} =~ /IRIX|ALPHA/) {
        die("Sling::Contrib::ContribVolbl::This must be run on Linux\n"); 
    }
    
    # Clean/strip pdb
    if (!-e $pdbCleanContrib) {
	if (Sling::PdbContainsAA::PdbContainsAA($PDB)) {
	    @CLEANPDB = Sling::PdbClean::PdbClean($PDB);
	} else {
	    die("Sling::Contrib - This PDB does not contain any amino acids.\n");
	}
	
        # Write clean .pdb file
        open (OUT,"> $pdb_file") or die("Sling::Contrib::ContribVolbl::Couldn't open $pdb_file:$!");
	for($z=0;$z<=$#CLEANPDB;$z++) {
	    next if $CLEANPDB[$z]!~/^ATOM/;
	    print OUT $CLEANPDB[$z];
	}
	close OUT;
	
	# Calcuation
	`$CMD{'PDB2GALF_LINUX'} $pdb_file $p_name`;
	`$CMD{'DELCX_LINUX'} $p_name > /dev/null`;
	`$CMD{'MKALF_LINUX'} $p_name > /dev/null`;
	`$CMD{'VOLBL_LINUX'}  -s 1 -c 0 -p $pdb_file $p_name > $p_out`;
	`mv $p_name.1.contrib $pdbCleanContrib`;
	`rm $p_name*`;
    }    
}


sub ContribVolblHash {
    
    # Input/output variables
    my ($PDB) = @_;
    my %RETURN = {};
    print STDERR "Sling::Contrib::ContribVolblHash PDB=$PDB\n";

    # Paths
    my $CONTRIB_PATH = $CFG{'LOCAL_CONTRIB'}."/".substr($PDB,1,2);
    my $pdbCleanContrib = "$CONTRIB_PATH/$PDB.1.contrib";
    
    # Create .contrib.1 file (if necessary)
    Sling::Contrib::ContribVolbl($PDB);

    return ContribVolblHashLocal($pdbCleanContrib);
}

###################################################################################
# ContribVolblHashLocal
#
###################################################################################
sub ContribVolblHashLocal {
    
    # Input/output variables
    my ($localFilePath) = @_;
    my %RETURN = {};

    print STDERR "Sling::Contrib::ContribVolblHashLocal PDB=$localFilePath\n";    

    if (-e $localFilePath) {

	open(FILE,"<$localFilePath") or die "Contrib::ContribVolblHash::Couldn't open $localFilePath:$!";
	while (<FILE>) {
	    next if $_=~/^\#/;
	    next if $_=~/^\s+$/;
	    next if $_=~/^$/;
	    
	    $key = Sling::PdbParse::PdbParse_AtomNumber($_)."_".Sling::PdbParse::PdbParse_Chain($_);
	    if ($_ =~ /\s+(\d+)\s+([\w\s]+)\s+(\w+)\s(\w?)\s+(\d+)\s+(\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/) {
		$atomNumber = $1;
		$atomName = $2;
		$resName = $3;
		$chain = $4;
		$resNumber = $5;
		$vert = $6;
		$sa = $7;
		$ms = $8;
		#$key = Utilities::Trim::Trim($atomNumber)."_".Utilities::Trim::Trim($atomName);
		$key = Utilities::Trim::Trim($atomNumber);
		#print "-- $key -- $sa $ms\n";
		$RETURN{$key}{'SA'} = $sa;
		$RETURN{$key}{'MS'} = $ms;
	    }
	}
	return %RETURN;
	
    } else {
	die "Contrib::ContribVolblHashLocal - $localFilePath does not exist\n";
    }
}

###################################################################################
# ContribSurfaceAreaByCSV
# 
# %surfaceArea = Sling::Contrib::ContribSurfaceAreaFromHpc("1mbn","HEM","1","0");
# print $surfaceArea{'SA'};
# print $surfaceArea{'MS'};
#
###################################################################################
sub ContribSurfaceAreaFromHpc {

    my ($pdbId,$ligand,$ligandId,$chain) = @_;
    my $totalSa = 0.0;
    my $totalMs = 0.0;
    my %return = {};

    %contrib = ContribVolblHashLocal($CFG{'LOCAL_CONTRIB'}.'/'.substr($pdbId,1,2).'/'.$pdbId.'.1.contrib');
    
    $path = $CFG{'LOCAL_HPC'}.'/'.substr($pdbId,1,2).'/'."$pdbId.$ligand.$ligandId.$chain.lpc.poc";
    @file = Utilities::File::FileToArray($path);
    foreach (@file) {
	next if $_!~/ATOM/;
	$key = Utilities::Trim::Trim(Sling::PdbParse::PdbParse_AtomNumber($_));
	$totalSa += $contrib{$key}{'SA'};
	$totalMs += $contrib{$key}{'MS'};
	#print $key."\t";
	#print "SA: ".$contrib{$key}{'SA'}."\t";
	#print "MS: ".$contrib{$key}{'MS'}."\n";

    }
    $return{'SA'} = $totalSa;
    $return{'MS'} = $totalMs;

    return %return;
}


###################################################################################
# ContribSurfaceAreaByCSV
#
###################################################################################
sub ContribSurfaceAreaByCsv {

    my ($pdbId,$string) = @_;
    
    $pdbContribFile = $CFG{'LOCAL_CONTRIB'}.'/'.substr($pdbId,1,2).'/'.$pdbId.'.1.contrib';
    
    if (-e $pdbContribFile) {
	%contrib = ContribVolblHashLocal($pdbContribFile);
	#Utilities::Hash::HashPrintHashOfHash(%contrib);
	@atomNumbers = split /,/,$string;
	foreach (@atomNumbers) {
	    print $_."  ";
	    print "SA: ".$contrib{$_}{'SA'}."\t";
	    print "MS: ".$contrib{$_}{'MS'}."\n";
	}
    } else {
	die "Contrib::ContribSurfaceAreaByCsv - $pdbContribFile does not exist\n";
    }
}

END {}
1;
