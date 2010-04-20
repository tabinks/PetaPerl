package Sling::File;

use Sling::Configure;


################################################################
# pocketAtomCount
# 
# Created: January 16, 2006
################################################################
sub filePrintToStdout {
    
    my ($file,$prefix) = @_;
    
    open (FILE,"<$file") or die "Couldn't open $file\n";    
    while (<FILE>) {
	if ($prefix) {
	    print "$prefix ";
	}
	print $_;
    }
}

########################################################################
# FileToArray()
########################################################################
sub FileToArray {
    
    my ($file) = @_;
    my @returnArray = ();

    open (FILE,"<$file") or die "Couldn't open $file\n";    
    while (<FILE>) {
	push @returnArray, $_;
    }
    return @returnArray;
}

########################################################################
# ArrayToFile()
########################################################################
sub ArrayToFile {
    
    my $path = shift @_;
    my @array = @_;
    
    open (FILE, "> $path") or die("Sling::File::ArrayToFile - Couldn't open $path for writing:$!\n");
    foreach (@array) {
	print FILE $_;
    }
    close FILE;
}

END {}
1;
