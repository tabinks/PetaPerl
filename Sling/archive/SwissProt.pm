package Cath;

$VERSION     = 0.01;


sub get_cath_by_res( \%@ ) {

    my $CATH  = shift;
    my ($pdb,$chain,$res) = @_;

    foreach $dom ( %{ $CATH{$pdb}{$chain} } ) {
	foreach $seg ( %{ $CATH{$pdb}{$chain}{$dom} } ) {
	    $start = $CATH{$pdb}{$chain}{$dom}{$seg}{START};
	    $stop  = $CATH{$pdb}{$chain}{$dom}{$seg}{STOP};
	    if ($res>=$start && $res<=$stop) {
		$ccath = $CATH{$pdb}{$chain}{$dom}{$seg}{CATH};
		$c    = $CATH{$pdb}{$chain}{$dom}{$seg}{C};
		$a    = $CATH{$pdb}{$chain}{$dom}{$seg}{A};
		$t    = $CATH{$pdb}{$chain}{$dom}{$seg}{T};
		$h    = $CATH{$pdb}{$chain}{$dom}{$seg}{H};
		$cs    = $CATH{$pdb}{$chain}{$dom}{$seg}{S};
		$cn    = $CATH{$pdb}{$chain}{$dom}{$seg}{N};
		$ci    = $CATH{$pdb}{$chain}{$dom}{$seg}{I};

		@r = ($c,$a,$t,$h,$cs,$cn,$ci);
		return @r;
	    }
	}
    }
}


sub get_cath_info ( \%@ ) {

    my $CATH  = shift;

    my ($pdb,$chain) = @_;
    my $ccath, $c, $a, $t, $h, $cs, $cn, $ci;
    my @all_dom = ();

    foreach $dom ( %{ $CATH{$pdb}{$chain} } ) {
	foreach $seg ( %{ $CATH{$pdb}{$chain}{$dom} } ) {

		$ccath = $CATH{$pdb}{$chain}{$dom}{$seg}{CATH};
		$c    = $CATH{$pdb}{$chain}{$dom}{$seg}{C};
		$a    = $CATH{$pdb}{$chain}{$dom}{$seg}{A};
		$t    = $CATH{$pdb}{$chain}{$dom}{$seg}{T};
		$h    = $CATH{$pdb}{$chain}{$dom}{$seg}{H};
		$cs    = $CATH{$pdb}{$chain}{$dom}{$seg}{S};
		$cn    = $CATH{$pdb}{$chain}{$dom}{$seg}{N};
		$ci    = $CATH{$pdb}{$chain}{$dom}{$seg}{I};
		push @all_dom, $ccath;
#		@r = ($ccath,$c,$a,$t,$h,$cs,$cn,$ci);
#		print @r;
#		push (@all_dom, [ @r ]);
#		print @all_dom;
#		print "\n";
	    }
    }
    return @all_dom;
}

sub create_cath_hash {
    
    my $file = $_[0];

    %CATH = {};

    open FILE, "< $file" 
	or die "Couldn't open $file for writing.";
    
    while(<FILE>) {
	$_ =~ /([a-z0-9]{4}) ([a-z0-9]) (\d) \[(\d)\|[0-9a-z]:(\d+)\-[a-z0-9]:(\d+)\]\t(\d+):(\d+):(\d+):(\d+):(\d+):(\d+):(\d+):(\d+):(\d+\.\d+)/i;

	$CATH{$1}{$2}{$3}{$4}{START} = $5;
	$CATH{$1}{$2}{$3}{$4}{STOP}  = $6;
	$CATH{$1}{$2}{$3}{$4}{CATH}  = "$7.$8.$9.$10";       #sequence family 35% seq id
	$CATH{$1}{$2}{$3}{$4}{C}     = "$7"          ;       #sequence family 35% seq id
	$CATH{$1}{$2}{$3}{$4}{A}     = "$8";                 #sequence family 35% seq id
	$CATH{$1}{$2}{$3}{$4}{T}     = "$9";                 #sequence family 35% seq id
	$CATH{$1}{$2}{$3}{$4}{H}     = "$10";                #sequence family 35% seq id
	$CATH{$1}{$2}{$3}{$4}{S}     = "$11";                #sequence family 35% seq id
	$CATH{$1}{$2}{$3}{$4}{N}     = "$12";                #near identical family 95% 
	$CATH{$1}{$2}{$3}{$4}{I}     = "$13";                #near identical family 95% 
    }
    close FILE;

    return %CATH;
}

# module clean-up code here (global destructor)
END { }       

1;
     
