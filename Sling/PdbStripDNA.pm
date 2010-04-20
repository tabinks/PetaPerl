package Sling::PdbStripDNA;

use Sling::Configure;
use Sling::PdbParse;

sub PdbStripDNA {
    
    my (@PDB) = @_;
    my @return_array=();
    
    print STDERR "Sling::PdbStripDna - Begin\n";
    foreach (@PDB) {
	next if $_!~/^ATOM|HETATM/;
	next if Sling::PdbParse::PdbParse_ResidueName($_) eq 'A';
	next if Sling::PdbParse::PdbParse_ResidueName($_) eq 'T';
	next if Sling::PdbParse::PdbParse_ResidueName($_) eq 'C';
	next if Sling::PdbParse::PdbParse_ResidueName($_) eq '+C';
	next if Sling::PdbParse::PdbParse_ResidueName($_) eq 'G';
	next if Sling::PdbParse::PdbParse_ResidueName($_) eq 'U';
	next if Sling::PdbParse::PdbParse_ResidueName($_) eq '+U';
	push @return_array,$_;
    }
    print STDERR "Sling::PdbStripDna - Returning array\n";
    return @return_array;
}

END {}
1;
