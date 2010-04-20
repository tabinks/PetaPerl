package Sling::Residue2Pocket;

use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;
use Sling::Array;

sub Residue2Pocket {

    my ($PDB,$RESIDUE) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.poc";
    
    my @return_array = ();    

    #######################################################
    #
    # Slurp the file into array
    #######################################################
    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
	next if $_=~/^$/;
	if ($RESIDUE == Sling::PdbParse::PdbParse_ResidueNumber($_)) {
	    $key = Sling::PdbParse::PdbParse_Pocket($_).'_';
	    $key .= $AminoAcids{Sling::PdbParse::PdbParse_ResidueName($_)}.'_';
	    $key .= Sling::PdbParse::PdbParse_ResidueName($_);
	    push @return_array, $key;
	}
    }
    close FILE;

    @RETURN_UNIQUE = Sling::Array::ArrayUnique(@return_array);
    return @RETURN_UNIQUE;
}

END {}
1;
