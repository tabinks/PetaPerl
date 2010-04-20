package Sling::DpcSurface;

use Sling::Configure;
use Sling::PdbParse;
use Sling::PdbFixNMR;
use Sling::Array;
use Sling::File;
use Sling::PdbLineByAtom;
use File::stat;
use Sling::PdbContainsAA;
use Sling::PdbContainsDNA;

sub DpcSurface {
    
    my ($PDB) = @_;    

    print STDERR "Sling::DpcSuface::DpcSurface()\n";
    
    my $DPC_PATH =  $CFG{'LOCAL_DPC'}.'/'.substr($PDB,1,2).'/'; 
    my $PREFIX = $PDB."_dna";
    my $OUTFILE = "$DPC_PATH/$PDB.dna.poc";
    my $TMP_DIR = "/tmp";
    
    my $pdb_dna_file  = "$TMP_DIR/$PREFIX.dna.pdb";
    my $p_dna_name    = "$TMP_DIR/$PREFIX.dna";
    my $p_dna_out     = "$TMP_DIR/$PREFIX.dna.output";
    my $output        = "$TMP_DIR/$PREFIX.diff";
    

    if (!-z $OUTFILE && -e $OUTFILE && stat($OUTFILE)->size>2) {
	Sling::Verbose::Verbose("Sling::DpcSurface::DpcSurface - $OUTFILE already exists\n");
      } else {
	  if (Sling::PdbContainsAA::PdbContainsAA($PDB) && !Sling::PdbContainsDNA::PdbContainsDNA($PDB)) {
	      Sling::Verbose::Verbose("Sling::DpcSurface::DpcSurface - $PDB does not contain any DNA\n");
	    } else {
		%lookup = Sling::Contrib::ContribVolblHash($PDB);
		@fileDna = Sling::PdbFixMSE::PdbFixMSE(Sling::PdbFixNMR::PdbFixNMR($PDB));
		@fileNoDna = Sling::PdbClean::PdbClean($PDB); # File without DNA
		Sling::File::ArrayToFile($pdb_dna_file,@fileDna);
		
		# Calcuation
		`$CMD{'PDB2GALF_LINUX'} $pdb_dna_file $p_dna_name`;
		`$CMD{'DELCX_LINUX'} $p_dna_name > /dev/null`;
		`$CMD{'MKALF_LINUX'} $p_dna_name > /dev/null`;
		`$CMD{'VOLBL_LINUX'} -s 1 -c 0 -p $pdb_dna_file $p_dna_name > $p_dna_out`;
		
		##############################################################
		# create .lpc.poc file
		##############################################################
		print STDERR "OUTFILE: $OUTFILE\n";
		%lookupWithDna = Sling::Contrib::ContribVolblHashLocal("$p_dna_name.1.contrib");
		
		open (OUT, "> $OUTFILE") or die "Couldn't open $OUTFILE\n";
		print OUT "\n";
		foreach $key (sort keys %lookupWithDna ) {
		    if ( $lookupWithDna{$key}{'SA'}!=$lookup{$key}{'SA'} || 
			 $lookupWithDna{$key}{'MS'}!=$lookup{$key}{'MS'} || 
			 !defined($lookup{$key}{'SA'}) ) {
			#print "$key\t\t $lookupWithDna{$key}{'SA'} - $lookup{$key}{'SA'}\n";
			($atomNumber,$atomName) = split(/_/,$key);
			print OUT Sling::PdbLineByAtom::PdbLineByAtom($atomNumber,@fileNoDna);
		    }
		}
		close(OUT);
		`sort -n +1 $OUTFILE > $TMP_DIR/$PDB; mv $TMP_DIR/$PDB $OUTFILE`;
		`rm $TMP_DIR/$PDB*`;
	    }
      }
}


END {}
1;
