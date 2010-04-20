package Utilities::Tanimoto;

#########################################################################################
#
#
########################################################################################
sub Tanimoto {
    my ($query,$library,$union) = @_;
    my $tanimoto = -0.0; 
    my $overlap = $query + $library - $union;
    
    if ($query>0 && $library>0 && $union>0) {
	if ($query + $library - $overlap>=0) {
	    $tanimoto = $overlap / ($query + $library - $overlap);
	}
    }
    return $tanimoto;
}

END {}
1;
