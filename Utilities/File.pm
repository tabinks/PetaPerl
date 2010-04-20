package Utilities::File;

$DEBUG=0;

################################################################
# pocketAtomCount
# 
# Created: January 16, 2006
################################################################
sub FilePrintToStdout {
    
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
    
    my ($file,$nice) = @_;
    my @returnArray = ();

    if (-e $file) {
	open (FILE,"<$file") or die "Couldn't open $file\n";    
	while (<FILE>) {
	    chomp;
	    push @returnArray, $_;
	}
	return @returnArray;
    } else {
	if ($nice) {
	    print "Utilities::File - $file does not exist\n";
	} else {
	    die "Utilities::File - $file does not exist\n";
	}
    }
}

########################################################################
# ArrayToFile()
########################################################################
sub FileArrayToFile {
    
    my $path = shift @_;
    my @array = @_;
    
    open (FILE, "> $path") or die("Sling::File::ArrayToFile - Couldn't open $path for writing:$!\n");
    foreach (@array) {
	if ($DEBUG ) {print $_;}
	printf FILE $_;
    }
    close FILE;
}

END {}
1;
