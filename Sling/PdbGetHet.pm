package Sling::PdbGetHet;

use Sling::Configure;
use Sling::PdbParse;
use Sling::PdbFixNMR;
use Sling::Array;

sub PdbGetHet {
    
    my ($PDB) = @_;
    my @CLEANPDB = ();
    my @RETURN = ();
    my @RETURN_UNIQUE=();

    @CLEANPDB = Sling::PdbFixNMR::PdbFixNMR($PDB);
    foreach (@CLEANPDB) {
	next if $_!~/^HETATM/;
        $res_name = Sling::PdbParse::PdbParse_ResidueName($_);
	next if $res_name =~ /HOH|MSE/;
	$chain = Sling::PdbParse::PdbParse_Chain($_);
        $res_number  = Sling::PdbParse::PdbParse_ResidueNumber($_);
	push @RETURN, "$res_name $res_number $chain";
    }
    @RETURN_UNIQUE = Sling::Array::ArrayUnique(@RETURN);
    return @RETURN_UNIQUE;
}

#####################################################################
# PdbGetHetAtoms
#
# Author: T.A. Binkowski
# Date: December 14, 2006
#
# Description: Returns a chomped array of all atoms that are HETATM.
#####################################################################
sub PdbGetHetAtoms {
    
    my ($PDB) = @_;
    my @CLEANPDB = ();
    my @RETURN = ();

    @CLEANPDB = Sling::PdbFixNMR::PdbFixNMR($PDB);
    foreach (@CLEANPDB) {
	chomp;
	next if $_!~/^HETATM/;
	next if Sling::PdbParse::PdbParse_ResidueName($_) =~ /HOH|MSE/;
	push @RETURN, $_;
    }
    return @RETURN;
}

END {}
1;
