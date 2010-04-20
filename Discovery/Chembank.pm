package Discovery::Chembank;

use Discovery::Configure;

##################################################################################
# Date
# 
# Author: T.A. Binkowski
# Date:   October 31, 2005
#
# Description: Returns all date stamps in a consistent manner: YYYYMMDD.
#              
#
##################################################################################
sub ChembankImageCurl {
    
    my ($id) = @_;
    my $width=200;
    my $height=90;
    my $outFile = $CFG{'CHEMBANK_IMAGES'}."/chembank_$id.png";
    
    `curl "http://chembank.broad.harvard.edu/chemistry/moleculeDepictPNG.htm?cbid=$id&width=$width&height=$height" > $outFile`;
}

######################################################################################
# ChembankSmilesDbQuery
#
######################################################################################
sub ChembankSmilesDbQuery {
    
    my ($smiles) = @_;

    $dbh = DBI->connect( "dbi:SQLite:".$CFG{'CHEMBANK_DB'}) || die "Cannot connect: $DBI::errstr";

    $results = $dbh->selectall_arrayref("SELECT * from chemBank where smiles=='$smiles';");
    foreach (@$p) {
	print "$_->[0] $_->[1]\n";
    }
    $dbh->disconnect;
}

END {}
1;
