package Sling::GpssFileTests;

use Sling::Configure;

sub CastpFilesExist {
    
    my ($PDB) = @_;

    $file = $CFG{'LOCAL_CAST'}.'/'.substr($PDB,1,2).'/'.$PDB;

    if (-e "$file.pdb" &&
	-e "$file.poc" &&
	-e "$file.pocInfo" &&
	-e "$file.mouth" &&
	-e "$file.mouthInfo") {
	return 1;
    } else {
	return 0;
    }
}

sub PdbFilesExist {
    
    my ($PDB) = @_;

    if (-e $CFG{'LOCAL_CAST'}.'/'.substr($PDB,1,2)."/$PDB.pdb" &&
	-e $CFG{'LOCAL_PDB'}.'/'.substr($PDB,1,2)."/$PDB.pdb" ) {
	return 1;
    } else {
	return 0;
    }
}

#########################################################################
# xmlFilesExist
#########################################################################
sub XmlFilesExist {

    my ($PDB) = @_;

    if (-e $CFG{'LOCAL_XML'}."/".substr($PDB,1,2)."/$PDB-noatom.xml") {
	#&& -e $CFG{'LOCAL_XML'}."/".substr($PDB,1,2)."/$PDB.xml") {
	return 1;
    } else {
	return 0;
    }
}

END {}
1;
