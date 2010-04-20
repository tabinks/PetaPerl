package Sling::PdbParse;

use Sling::Trim;

########################################################
# PdbParseChain
#
########################################################
sub PdbParse_Chain {

    $chain = substr($_[0],21,1);
    if ($chain eq ' ') {$chain=0;}
    return $chain;
}

########################################################
# PdbParseResidueName
#
########################################################
sub PdbParse_ResidueName {
    return Sling::Trim::Trim(substr($_[0],17,3));
}

########################################################
# PdbParseResidueNumber
#
########################################################
sub PdbParse_ResidueNumber {
    return Sling::Trim::Trim(substr($_[0],22,4));
}

########################################################
# PdbParse_Atom*
#
########################################################
sub PdbParse_AtomNumber {
    return Sling::Trim::Trim(substr($_[0],6,5));
}
sub PdbParse_AtomName {
    return Sling::Trim::Trim(substr($_[0],12,4));
}

sub PdbParse_Pocket {
    return Sling::Trim::Trim(substr($_[0],67,4));
}


END {}
1;
