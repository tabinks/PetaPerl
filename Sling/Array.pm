package Sling::Array;

use lib '/home/tbinkowski/lib';
use Sling::Trim;

#############################################################
# ArrayUnique
#
#############################################################
sub ArrayUnique {
    my @list = @_;
    my %seen = ();
    my @uniq = ();

    foreach $item (@list) {
	push(@uniq, $item) unless $seen{$item}++;
    }

return @uniq;
}

#############################################################
# ArrayInArray
#
#############################################################
sub ArrayInArray {
 
    my ($string,@array) = @_;
    my $MATCH=0;
    foreach (@array) {
        if ($_ eq $string) {
            $MATCH=1;
        }
    }
    return $MATCH;
}

END {}
1;
