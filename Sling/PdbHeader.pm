package Sling::PdbHeader;

use Sling::Configure;
use Sling::Trim;

########################################################
# PdbHeader_Header
#
########################################################
sub PdbHeader_Header {
    
    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    
    my $string="";

    open (PDBPATH, "< $PDBPATH");# or die "Couldn't open $PDBPATH:!$\n";
    while (<PDBPATH>) {
	next unless $_=~/^HEADER/;
	if($_=~/^HEADER\s+(.*)\s+(\d+\-\w+\-\d+)/ ||
	   $_=~/^HEADER\s+(.*\))(\d+\-\w+\-\d+)/       # some end in )date with no space
	   ) {
	    $string=$1;
	    $string =~s/\"//g;
	    $string =~s/\'//g;
	}
    }
    $retString = Sling::Trim::Trim($string);
    if ($retString eq '') {
	$retString = "-";
    }
    return Sling::Trim::Underscore($retString);
}

########################################################
#
########################################################
sub PdbHeader_Title {
    
    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    
    my $string="";

    open (PDBPATH, "< $PDBPATH");# or die "Couldn't open $PDBPATH:!$\n";
    while (<PDBPATH>) {
	next unless $_=~/^TITLE/;
	if($_=~/^TITLE\s+(.*)/) {
	    $string.=$1;
	}
    }
    $string =~s/\"//g;
    $string =~s/\'//g;
    $retString = Sling::Trim::Trim($string);
    if ($retString eq '') {
	$retString = "-";
    }
    return Sling::Trim::Underscore($retString);
}


END {}
1;
