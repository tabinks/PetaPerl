package Utilities::Verbose;

sub Verbose {

    my ($value,$string) = @_;
    
    if ($value==1) {
	print "$string\n";
    }
}
END {}
1;
