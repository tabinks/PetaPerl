package Sling::PdbSingleChainFile;

use Sling::Configure;
use Sling::PdbParse;
use Sling::Array;

sub PdbSingleChainFile {

    my ($PDB,$CHAIN,$PATH) = @_;
    my @chains = ();

    my $outFile = "$PATH/$PDB.$CHAIN.pdb";
    my @file_nmr = Sling::PdbFixNMR::PdbFixNMR($PDB);

    open (FILE, "> $outFile") or die "PdbSingleChainFile: Couldn't open $outFile: $!";

    foreach $fileLine (@file_nmr) {
	next unless $fileLine =~/^ATOM/;
	
	if (Sling::PdbParse::PdbParse_Chain($fileLine) eq $CHAIN) {
	    print FILE $fileLine;
	}
    }
    close FILE;

    return $outFile;
}


sub PdbSingleChainLength {

#    my ($PDB,$CHAIN) = @_;
#    my @chains = ();

#    my $outFile = "$PATH/$PDB.$CHAIN.pdb";
#    my @file_nmr = Sling::PdbFixNMR::PdbFixNMR($PDB);

#    open (FILE, "> $outFile") or 
#	die "PdbSingleChainFile: Couldn't open $outFile: $!";

#    foreach $fileLine (@file_nmr) {
#	next unless $fileLine =~/^ATOM/;
	
#	if (Sling::PdbParse::PdbParse_Chain($fileLine) eq $CHAIN) {
	    #$key = Sling::PdbParse::PdbParse_
#	    print FILE $fileLine;
#	}
#    }
#    close FILE;

#    return $outFile;
}

END {}
1;
