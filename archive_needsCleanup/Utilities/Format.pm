package Tab::Format;

require Exporter;
use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&EasyRead);

sub EasyRead {
    my $tmp = $_[0];
    my $meg =0;
    my $pos =0;
    my $waiting=0;
    my $tmpPattern;

    @tmp = &Tab::Text::GetC($tmp);
    foreach (@tmp) {
	if ($_ eq "-") {
	    if ($waiting==0) {
		if ($pos!=0) {
		    $tmpPattern .= $pos;
		    $pos=0;
		}
	        $tmpPattern .= "(";
		$waiting = 1;
	    }
	    $neg++;
	} elsif ($_ eq "+") {
	    if ($waiting==1) {
		$tmpPattern .= $neg;
		$tmpPattern .= ")";
		$neg=0;
		$waiting=0; 
	    }
	    $pos++;
	}
    }
    if ($waiting==1) {
	$tmpPattern .= $neg;
	$tmpPattern .= ")";
    } else {
	$tmpPattern .= $pos;
    }
    return $tmpPattern;
}
 
END { }      

1;
