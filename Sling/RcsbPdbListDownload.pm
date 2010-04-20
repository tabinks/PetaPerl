package Sling::RcsbPdbListDownload;

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
sub rcsbPdbListDownload {

    my ($filePath) = @_;
    my @returnArray;
    
    `wget -q -O $filePath ftp://ftp.rcsb.org/pub/pdb/data/structures/ls-lR`;
    
    open(FILE,"< $filePath") or die "Couldn't open $filePath: $!";
    while (<FILE>) {
	if ($_ =~ /divided\/XML\/[a-z0-9]{2}\/([a-z0-9]{4})/i) {
	    push @returnArray, $1;
	}
    }
    close FILE;

    return @returnArray;
}

END {}
1;
