package Scop;

$VERSION     = 0.01;

sub get_scop_by_res( \%@ ) {

    my $scop  = shift;
    my ( $pdb, $chain, $res) = @_;

    @r = ();
    foreach $dom ( %{ $scop{$pdb}{$chain} } ) {
        foreach $seg ( %{ $scop{$pdb}{$chain}{$dom} } ) {
            $start = $scop{$pdb}{$chain}{$dom}{$seg}{START};
            $stop  = $scop{$pdb}{$chain}{$dom}{$seg}{STOP};
            if ($res>=$start && $res<=$stop) {
		$id          = $scop{$pdb}{$chain}{$dom}{$seg}{SCOP};
		$class       = $scop{$pdb}{$chain}{$dom}{$seg}{CLASS};
		$fold        = $scop{$pdb}{$chain}{$dom}{$seg}{FOLD};
		$superfamily = $scop{$pdb}{$chain}{$dom}{$seg}{SUPERFAMILY};
		$family      = $scop{$pdb}{$chain}{$dom}{$seg}{FAMILY};
                @r = ( $id, $class, $fold, $superfamily, $family );
                return @r;
            }
        }
    }
    return @r;
}

sub get_scop_info ( \%@ ) {

    my $scop  = shift;

    my ($pdb,$chain) = @_;
    my $ccath, $c, $a, $t, $h, $cs, $cn, $ci;
    my @all_dom = ();

    foreach $dom ( %{ $scop{$pdb}{$chain} } ) {
	foreach $seg ( %{ $scop{$pdb}{$chain}{$dom} } ) {
		$id    = $scop{$pdb}{$chain}{$dom}{$seg}{SCOP};
		$class = $scop{$pdb}{$chain}{$dom}{$seg}{CLASS};
		$fold  = $scop{$pdb}{$chain}{$dom}{$seg}{FOLD};
		$superfamily = $scop{$pdb}{$chain}{$dom}{$seg}{SUPERFAMILY};
		$family = $scop{$pdb}{$chain}{$dom}{$seg}{FAMILY};
		push @all_dom, $id;
	    }
    }
    return @all_dom;
}

sub create_scop_hash {
    
    my $file = $_[0];

    %scop = {};

    open FILE, "< $file" 
	or die "Couldn't open $file for writing.";
    
    while(<FILE>) {
	$_ =~ /([a-z0-9]{4}) ([a-z0-9]) (\d) \[(\d)\|[0-9a-z]:(\d+)\-[a-z0-9]:(\d+)\]\s([a-z])\.(\d+)\.(\d+)\.(\d+)/i;

	$scop{$1}{$2}{$3}{$4}{START} = $5;
	$scop{$1}{$2}{$3}{$4}{STOP}  = $6;
	$scop{$1}{$2}{$3}{$4}{SCOP}        = "$7.$8.$9.$10";     
	$scop{$1}{$2}{$3}{$4}{CLASS}       = "$7";     
	$scop{$1}{$2}{$3}{$4}{FOLD}        = "$8";               
	$scop{$1}{$2}{$3}{$4}{SUPERFAMILY} = "$8";              
	$scop{$1}{$2}{$3}{$4}{FAMILY}      = "$8";              
    }
    close FILE;

    return %scop;
}

# module clean-up code here (global destructor)
END { }       

1;
     
