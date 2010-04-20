package Sling::Date;


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
sub date {

    my $date = `date +%Y%m%d`;
    chomp($date);

    return $date;
}

END {}
1;
