package Tab::Window;

use Tab::Text;
use strict;

require Exporter;

use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&Create);

use vars       qw(@origSeq $tmpSeq $pass $mod $length $newSeq @newSeq $i $j);

sub Create{ 
    my %args = (
		INPUT     =>  1,
		WINDOW    =>  1,
		PERIOD    =>  1,
		@_
		);
    
    $length = length($args{INPUT});
    $pass   = int( $length / ( $args{WINDOW}+$args{PERIOD} ) );
    $mod    =  $length % ($args{WINDOW}+$args{PERIOD});
    $newSeq = ($args{WINDOW}+$args{PERIOD});
    
    if ($args{WINDOW} < $mod) {
	$pass++;
    }
    
    # Original Sequence
    #push @newSeq, $args{INPUT};

    # Each New Sequence
    for ($j=0; $j<$newSeq; $j++) {
    
    # New sequence creation
    for ($i=$j;$i<$length;$i=$i+$args{PERIOD}+$args{WINDOW}) {
	$tmpSeq .= substr($args{INPUT}, $i, $args{WINDOW});
    }
    
    push @newSeq, $tmpSeq;
    $tmpSeq = "";    
    }

    return @newSeq;
}
 
END { }      

1;
