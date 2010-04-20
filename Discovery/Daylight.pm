package Discovery::Daylight;

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

##################################################################################
# Daylight::DaylightImageCurl
#
#
# Small: 96x64 
# Wide:  400x200
# Med:   240x200
# Large: 640x480   
##################################################################################
sub DaylightImageCurl {
    
    my ($smiles,$id,$outputPath) = @_;

    if (!$id) {
	print "Need to assign an id to the image\n";
	exit;
    }
    
    my $hexString = `/home/tbinkowski/bin/bin2hex "$smiles #w=240 #h=200 #c=22"`;
    `curl "www.daylight.com/daycgi/smi2gif?$hexString" > $outputPath/$id.gif`;
}

END {}
1;
