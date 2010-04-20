package Sling::Dna;

require Exporter;
use Sling::Configure;
use Sling::PdbParse;
use Sling::AminoAcids;
use Sling::PdbContainsAA;
use Sling::Array;

@ISA         = qw(Exporter);
@EXPORT      = qw(%DnaBases);

use vars       qw(%DnaBases);

%DnaBases = ( 
	      'A'  => 'ADENINE',
	      'T'  => 'THYMINE',
	      'C'  => 'CYTOSINE',
	      '+C' => 'CYTOSINE',
	      'G'  => 'GUANINE',
	      'U'  => 'URACIL',
	      '+U' => 'URACIL',
	      '5NC' => '5-AZA-CYTIDINE-5 MONOPHOSPHATE'
	      );

sub DnaBasePairCount {
    my ($PDB) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    my $PDBPATH = $CFG{'LOCAL_CAST'}."/$PDBDIR/$PDB.pdb";
    
    my @return_array = ();
    my @return_unique = ();
    
    print "$PDBPATH\n";
    open (FILE,"< $PDBPATH") or die "Couldn't open $PDBPATH\n";
    while (<FILE>) {
        next if $_=~/^$/;
        next if $_!~/^ATOM/;
        if ( $DnaBases{Sling::PdbParse::PdbParse_ResidueName($_)} ) {
            $chain = Sling::PdbParse::PdbParse_Chain($_);
            $residue_number = Sling::PdbParse::PdbParse_ResidueNumber($_);
            $key = $chain."_".$residue_number;
            push @return_array, $key;
        }
    }
    close FILE;

    @return_unique = Sling::Array::ArrayUnique(@return_array);
    return $#return_unique+1;
}

END {}
1;























