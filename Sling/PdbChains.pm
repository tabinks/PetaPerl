package Sling::PdbChains;

use Sling::Configure;
use Sling::PdbParse;
use Sling::Array;
use Sling::PdbFixNMR;
use Sling::AminoAcids;

sub PdbChains {

    my ($PDB) = @_;
    my @chains = ();
    
    my @file_nmr = Sling::PdbFixNMR::PdbFixNMR($PDB);
    foreach $fileLine (@file_nmr) {
	next unless $fileLine =~/^ATOM/;
	push @chains, Sling::PdbParse::PdbParse_Chain($fileLine);
    }

    return Sling::Array::ArrayUnique(@chains);
}

sub PdbChainsSequence {

    my ($PDB,$CHAIN) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    my @seen = ();
    my @sequence = ();

    open (FILE,"<$PDBPATH") or die "Couldn't open $PDBPATH\n";    
    while (<FILE>) {
        next if $_!~/^ATOM/;
        $chain = Sling::PdbParse::PdbParse_Chain($_);
	if($CHAIN eq $chain) {
	    $residue_number = Sling::PdbParse::PdbParse_ResidueNumber($_);
	    $residue_name = Sling::PdbParse::PdbParse_ResidueName($_);
	    $key = $residue_number."_".$chain;    

	    if (!Sling::Array::ArrayInArray($key,@seen)) {
		push @seen, $key;
		push @sequence, $AminoAcids{$residue_name};
	    } 
	}
    }
    close FILE;
    print @sequence;
    return @sequence;
}

sub PdbChainToFile {
    my ($PDB,$CHAIN,$PATH,$PREFIX) = @_;
    $PDB = lc($PDB);
    my @chains = ();

    my $PATH=($PATH)?$PATH:"./";
    my $outFile = ($PREFIX)?"$PATH/$PREFIX.pdb":"$PATH/$PDB"."_"."$CHAIN.pdb";

    my @file_nmr = Sling::PdbFixNMR::PdbFixNMR($PDB);

    print STDERR "$PDB $CHAIN has ".scalar(&PdbChainsSequence($PDB,$CHAIN))."\n";

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

END {}
1;
