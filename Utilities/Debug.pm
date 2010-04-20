package Utilities::Debug;

sub Debug {
    
    my ($value,$string) = @_;
    
    if ($value==1) {
	print $string;
    }
}
END {}
1;
