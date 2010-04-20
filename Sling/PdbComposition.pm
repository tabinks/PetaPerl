package Sling::PdbComposition;

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
sub PdbComposition {

    my ($PDB) = @_;
    
    my @return_array = ();    
    my @return_unique = ();

    my %compositionHash = ();
    my %compositionHash = ("ALA"=>0,"ARG"=>0,"ASN"=>0,"ASP"=>0,
			   "CYS"=>0,"GLN"=>0,"GLU"=>0,"GLY"=>0,
			   "HIS"=>0,"ILE"=>0,"LEU"=>0,"LYS"=>0,
			   "MET"=>0,"PHE"=>0,"PRO"=>0,"SER"=>0,
			   "THR"=>0,"TRP"=>0,"TYR"=>0,"VAL"=>0);
    
    if (Sling::PdbContainsAA::PdbContainsAA($PDB)) {
	@file = Sling::PdbClean::PdbClean($PDB); # Load Pdb file and clean it (remove DNA, NMR)
	foreach (@file) {
	    next if $_=~/^$/;
	    next if $_!~/^ATOM/;
	    $residueName = Sling::PdbParse::PdbParse_ResidueName($_);
	    $chain = Sling::PdbParse::PdbParse_Chain($_);
	    $residue_number = Sling::PdbParse::PdbParse_ResidueNumber($_);
	    $key = $chain."_".$residue_number."_$residueName";
	    push @return_array, $key;
	}
	@return_unique = Sling::Array::ArrayUnique(@return_array);
	
	foreach (@return_unique) { 
	    #print "$_ ";
	    ($chain,$residueNumber,$residueName) = split /_/;
	    $compositionHash{$residueName}++;
	}
	#Sling::Hash::HashPrint(%compositionHash);
	return %compositionHash;
    }
}

END {}
1;
