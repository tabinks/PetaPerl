package Utilities::Dictionary;

################################################################
# LookupEC
#    
#
################################################################
sub DictionaryFromFile {

    my ($FILE) = @_;
    my %return_hash={};
    
    open (FILE,"< $FILE  ") or die "Couldn't open $FILE\n";    
    while (<FILE>) {
	($key,$value) = split;
	
	# Allow a single column list to act as a hash
	if (!defined $value or $value eq '') { 
	    $value = 1;
	}
	$return_hash{$key} = $value;
    }
    close FILE;
    return %return_hash;

}

################################################################
# HashLookup
#    
#
################################################################
sub DictionaryFromFileWithColumn {
    my ($FILE,$column) = @_;
    open (FILE,"< $FILE") or die "Couldn't open $FILE\n";    
    while (<FILE>) {
	@line=split/\s+/;
	$key=$line[0];
	$value=$line[$column];
	$return_hash{$key} = $value;
    }
    close FILE;
    return %return_hash;
}
    
################################################################
# HashLookup
#    
#
################################################################
sub DictionaryLookup {

    my ($key,%hash) = @_;
    
    if (defined $hash{$key}) {
	return $hash{$key};
    } else {
	return "-";
    }
}

sub HashLookupBoolean {
    
    my ($key,%hash) = @_;
    
    if (defined $hash{$key}) {
	return $hash{$key};
    } else {
	return 0;
    }
}

################################################################
# HashPrint
#    
#
################################################################
sub DictionaryPrint {
    
    my %hash = @_;
    
    while ( ($k,$v) = each %hash ) {
	print "$k => $v\n";
    }
}

sub HashPrintHashOfArrays {
    
    my %hash = @_;
    
    foreach $family ( keys %hash ) {
	print "$family: \n";
	foreach $i (0..$#{ $hash{$family} } ) {
	    print " $i = $hash{$family}[$i]\n";
	}
	print "\n";
    }
    print "\n";
}

sub HashPrintHashOfHash {
    
    my %hash = @_;
    
    foreach $family ( sort keys %hash ) {
	print "$family: \n";
	foreach $role (sort keys %{ $hash{$family} } ) {
	    print " $role = $hash{$family}{$role}\n";
	}
	print "\n";
    }
    print "\n";
}


END {}
1;
