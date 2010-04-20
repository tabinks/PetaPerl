package Sling::HpcSurface;

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

sub HpcSurface {

    my ($PDB) = (@_);
    
    print STDERR "Sling::HpcSurface::HpcSurface()";
    %mmcif = Sling::HpcMmcifHash::HpcMmcifHashLoad( $CFG{'LOCAL_MMCIF'} );
    %lookup = Sling::Contrib::ContribVolblHash($PDB);
    
    my $DATE = Sling::Date::date();
    my $CAST_DIR =  $CFG{'LOCAL_CAST'};
    my $CONTRIB_PATH = $CFG{'LOCAL_CONTRIB'}."/".substr($PDB,1,2); 
    mkpath($CONTRIB_PATH);
    my $HPC_PATH =  $CFG{'LOCAL_HPC'}.'/'.substr($PDB,1,2).'/'; 
    mkpath($HPC_PATH);
    my $PROJECT_DIR = '/home/tbinkowski/projects/slingManage/hpc/';
    my $LOGFILE = "$PROJECT_DIR/scripts/LOGS/HPC_surfacePdb.$DATE.log";
    my $BIN_PATH = $PROJECT_DIR.'bin/';
    my $TMP_DIR = $PROJECT_DIR.'/scripts/tmp/';
    
    
    @file = Sling::PdbClean::PdbClean($PDB); # Load Pdb file and clean it (remove DNA, NMR)
    @hets = Sling::PdbGetHet::PdbGetHet($PDB); # Go through each HET
    
    foreach (@hets) {	
	print STDERR "Working On: $_\n";
	($LIGAND, $LIGAND_NUMBER, $CHAIN) = split /\s+/;
	#next if defined $XtalArtifacts{$LIGAND}; # Don't run xtal artifacts
	#next if defined $Metals{$LIGAND}; # Don't run xtal artifacts
	#next if Sling::HpcMmcifHash::HpcMmcifHashLookup($LIGAND,"FORMULA_WEIGHT",%mmcif) < 100;
	
	$PREFIX = "$PDB.$LIGAND.$LIGAND_NUMBER.$CHAIN";
	$OUTFILE = "$HPC_PATH/$PREFIX.lpc.poc";
	$OUTFILE_CONTRIB = "$HPC_PATH/$PREFIX.1.contrib";
	
	if (!-z $OUTFILE && -e $OUTFILE && stat($OUTFILE)->size>2) {
	    print STDERR "- $OUTFILE already exists\n";
	} else {
	    print STDERR "- $OUTFILE doesn't exist, and were doing it.";
	    $pdb_lig_file  = "$TMP_DIR/$PREFIX.lig.pdb";
	    $p_lig_name    = "$TMP_DIR/$PREFIX.lig";
	    $p_lig_out     = "$TMP_DIR/$PREFIX.lig.output";
	    $output        = "$TMP_DIR/$PREFIX.diff";
	    
	    @tmp = ();        # for array of array
	    @return = ();     # returned array of array
	    @pdbfield  = ();  # for .diff file
	    
	    # Remove only the ligand in question
	    open (OUT,"> $pdb_lig_file") or die("Couldn't open $pdb_lig_file:$!");
	    for($z=0;$z<$#file;$z++) {
		if ($file[$z]=~/^ATOM/) { 	    # Include all atoms
		    print OUT $file[$z];
		}
		if ($file[$z] =~ /^HETATM/) {   # Print out the HET
		    if ( Sling::PdbParse::PdbParse_ResidueName($file[$z]) eq $LIGAND &&
			 Sling::PdbParse::PdbParse_ResidueNumber($file[$z]) == $LIGAND_NUMBER &&
			 Sling::PdbParse::PdbParse_Chain($file[$z]) eq $CHAIN) {
			print OUT $file[$z];
		    }
		}
	    }
	    close OUT;
	    #Sling::File::filePrintToStdout($pdb_lig_file,"pdbWithLigand: ");
	    
	    # Calcuation
	    `$CMD{'PDB2GALF_LINUX'} $pdb_lig_file $p_lig_name`;
	    `$CMD{'DELCX_LINUX'} $p_lig_name > /dev/null`;
	    `$CMD{'MKALF_LINUX'} $p_lig_name > /dev/null`;
	    `$CMD{'VOLBL_LINUX'} -s 1 -c 0 -p $pdb_lig_file $p_lig_name > $p_lig_out`;
	    
	    ##############################################################
	    # create .lpc.poc file
	    ##############################################################
	    print "OUTFILE: $OUTFILE\n";
	    %lookupWithLig = Sling::Contrib::ContribVolblHashLocal("$p_lig_name.1.contrib");
	    
	    open (OUT, "> $OUTFILE") or die "Couldn't open $OUTFILE\n";
	    print OUT "\n";
	    
	    foreach $key (sort keys %lookupWithLig ) {
		if ( $lookupWithLig{$key}{'SA'}!=$lookup{$key}{'SA'} || 
		     $lookupWithLig{$key}{'MS'}!=$lookup{$key}{'MS'} || 
		     !defined($lookup{$key}{'SA'}) ) {
		    ($atomNumber,$atomName) = split(/_/,$key);
		    print OUT Sling::PdbLineByAtom::PdbLineByAtom($atomNumber,@file);
		}
	    }
	    close(OUT);
	    
	    # Clean up tmp files
	    `sort -n +1 $OUTFILE > $TMP_DIR/$PDB; mv $TMP_DIR/$PDB $OUTFILE`;
	    `rm $TMP_DIR/$PDB*`;
	} 
	
	###################################################################
	# Use .lpc.poc vs. clean contrib.1 to get SA
	###################################################################
	if ($h) {
	    open(FILE,"<$OUTFILE") or die "Couldn't open $OUTFILE:$!";
	    while (<FILE>) {
		next if $_=~/^\#/;
		print $_;
		$atomNumber = Sling::PdbParse::PdbParse_AtomNumber($_);
		$atomChain = Sling::PdbParse::PdbParse_Chain($_);
		$key = "$atomNumber_$atomChain";
		$pdbfield[10] = Sling::Trim::Trim(substr($_,41,8)); # Asa
		if (!defined($lookup{$key}) || $lookup{$key}{'SA'} != $pdbfield[10]) {
		    print $_;
		}
	    }
	    close(FILE);
	}
    }
}

END {}
1;
