package Utilities::Array;

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
# ArrayMerge
#
#############################################################
sub ArrayMerge {
    my ($array1,$array2) = @_;
    my @newArray = ();

    foreach (@$array1) {
	push(@newArray, $_);
    }
    foreach (@$array2) {
	push(@newArray, $_);
    }
    
    return @newArray;
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

#############################################################
# ArrayInArray
#
#############################################################
sub ArrayPrintToStderr {
    
    my ($debug,@array) = @_;
    if ($debug) {
	foreach (@array) {
	    print STDERR ".....".$_.".....\n";
	}
    }
}

#############################################################
# ArrayInArray
#
#############################################################
sub ArrayPrintToFile {
    
    my ($fileName,@array) = @_;
    open(OUT,"> $fileName") or "Couldn't open $fileName:$!\n";
    foreach (@array) {
	print OUT $_."\n";
    }
}


#############################################################
# ArrayInArray
#
#############################################################

END {}
1;
