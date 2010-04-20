package Sling::SequenceComposition;

use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;
use Sling::PdbContainsAA;
use Sling::PdbClean;
use Sling::Array;
use Sling::Hash;
use File::Basename;

################################################################
# SurfaceComposition()
#    
################################################################
sub SequenceComposition {

    my ($SEQUENCE) = @_;
    
    my %compositionHash = ();
    my %compositionHash = ("ALA"=>0,"ARG"=>0,"ASN"=>0,"ASP"=>0,
			   "CYS"=>0,"GLN"=>0,"GLU"=>0,"GLY"=>0,
			   "HIS"=>0,"ILE"=>0,"LEU"=>0,"LYS"=>0,
			   "MET"=>0,"PHE"=>0,"PRO"=>0,"SER"=>0,
			   "THR"=>0,"TRP"=>0,"TYR"=>0,"VAL"=>0);
    
    $SEQUENCE =~ s/\n//g; # clean up
    #print "Sling::SequenceCompostion - $SEQUENCE\n";
    @sequenceArray = split(//,$SEQUENCE);
    foreach $aa (@sequenceArray) {
	$aA = $AminoAcids1To3{$aa};
	if ($aA) {
	    $compositionHash{$aA}++;
	}
    }

    #Sling::Hash::HashPrint(%compositionHash);
    return %compositionHash;
}

END {}
1;
