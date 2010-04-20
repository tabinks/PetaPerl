package Sling::Verbose;

use Sling::Configure;

sub Verbose {

    my ($string) = @_;
    
    if ($CFG{'VERBOSE'}==1) {
	print "$string\n";
    }
}
END {}
1;
