package Sling::HpcMmcifHash;

use Sling::Trim;

sub HpcMmcifHashLoad {
    
    my ($FILE) = @_;
    
    my %results = {};

    $results{COUNT}=0;

    open (POCINFO, "< $FILE") or die "Couldn't open $FILE:$!\n";
    while (<POCINFO>) {
	next if $_ =~ /^\s+$/;
        ($hetid,$pdbx_type,$pdbx_formal_charge,$formula_weight,$formula,$type,$name,$pdbx_synonyms) = split(/\|/,$_);
	$id = Sling::Trim::Trim($hetid);

	$results{$id}{$id}   = $id;
	$results{$id}{'PDBX_TYPE'} = Sling::Trim::Trim($pdbx_type);
	$results{$id}{'PDBX_FORMAL_CHARGE'} = Sling::Trim::Trim($pdbx_formal_charge);
	$results{$id}{'FORMULA_WEIGHT'} = Sling::Trim::Trim($formula_weight);
	$results{$id}{'FORMULA'} = Sling::Trim::Trim($formula);
	$results{$id}{'TYPE'} = Sling::Trim::Trim($type);
	$results{$id}{'NAME'} = Sling::Trim::Trim($name);
	$results{$id}{'PDBX_SYNONYMS'} = Sling::Trim::Trim($pdbx_synonyms);
	$results{'COUNT'}++;
    }
    close POCINFO;
    
    # return 
    return %results;
}

sub HpcMmcifHashLookup {
 
    my ($key,$key2,%hash) = @_;

    if (defined $hash{$key}{$key2}) {
	return Sling::Trim::Underscore($hash{$key}{$key2});
    } else {
        return "0.000";
    }
}



END {}
1;
