package Sling::PpcSurface;

use Sling::Configure;
use Sling::PdbParse;
use Sling::PdbFixNMR;
use Sling::Array;
use Sling::File;
use Sling::PdbLineByAtom;
use File::stat;
use Sling::PdbContainsAA;
use Sling::PdbContainsDNA;
use Sling::PdbLoad;
use File::Path;
use Sling::Verbose;

##########################################################################
# PpcSurface()
#
# Description:
# Calculate the surface resides between protein-protein interfaces.
# Temporarily place the pdb.chain files into p_ so that the volbl calculation
# can be more cleanly called from Contrib::ContribVolblHash, but removes it
# after completion.
#
# Usage: Sling::PpcSurface(pdbId,Chain)
#
#
##########################################################################
sub PpcSurface {
    
    my ($PDB,$CHAIN) = @_;    

    $OUTPATH = $CFG{'LOCAL_PPC'}."/".substr($PDB,1,2)."/";
    $OUTFILE = "$OUTPATH/$PDB.$CHAIN.ppc.poc";
    mkpath($OUTPATH);
    
    if (!-z $OUTFILE && -e $OUTFILE && stat($OUTFILE)->size>2) 
    {
	Sling::Verbose::Verbose("Sling::PpcSurface::PpcSurface - $OUTFILE already exists\n");
      } else {
	  
	  # Load in original PDB
	  @inputPdbArray = Sling::PdbLoad::PdbLoad($PDB);
	  
	  # open file and strip off chain
	  @cleanPdb = Sling::PdbClean::PdbClean($PDB); 
	  @stripPdb = Sling::PdbStripChain::PdbStripChain($CHAIN,@cleanPdb);
	  
	  # Write new clean pdb file to p_
	  $pdbClean = $CFG{'LOCAL_CAST'}."/p_/up_$PDB.$CHAIN.pdb";
	  #$pdbLocal = $CFG{'LOCAL_CAST'}."/p_/up_$PDB.pdb";
	  Sling::File::ArrayToFile($pdbClean,@stripPdb);
	  
	  %origLookup = Sling::Contrib::ContribVolblHash($PDB);
	  %newLookup = Sling::Contrib::ContribVolblHash("up_$PDB.$CHAIN");
	  
	  open (OUT, "> $OUTFILE") or die "Couldn't open $OUTFILE\n";
	  print OUT "\n";
	  
	  foreach $k (sort keys %origLookup) {
	      ($atomNumber,$atomName) = split(/_/,$k);
	      if ($origLookup{$k}{'SA'} != $newLookup{$k}{'SA'} ||
		  $origLookup{$k}{'MS'} != $newLookup{$k}{'MS'}) {
		  $line = Sling::PdbLineByAtom::PdbLineByAtom($atomNumber,@inputPdbArray);
		  if (Sling::PdbParse::PdbParse_Chain($line) ne $CHAIN) {
		      print OUT $line;
		  }
	      }
	  }
	  close(OUT);
	  #`rm -f $pdbLocal`;
	  `rm -f $pdbClean`;
      }
}


END {}
1;
