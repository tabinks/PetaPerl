package Discovery::MsdChem;

use Discovery::Configure;
use Utilities::File;
use Utilities::Hash;
use DBI;

sub MsdChemId2Smiles {

    my ($id) = @_;
    @id2smiles = Utilities::File::FileToArray($CFG{'MSDCHEM_SMILES'});
    foreach (@id2smiles) {
	($id3,$smiles) = split;
	if ($id3 eq $id) {
	    return $smiles;
	}
    }
    print STDERR "Discovery::MsdChem::MsdChemId2Smiles - 3 letter id was not in data file\n";
}

END {}
1;
