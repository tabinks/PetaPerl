package Utilities::Array;

sub array_unique {
    my @list = @_;
    my %seen = ();
    my @uniq = ();

    foreach $item (@list) {
	push(@uniq, $item) unless $seen{$item}++;
    }

return @uniq;
}

END {}
1;
