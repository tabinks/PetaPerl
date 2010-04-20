package Tab::Sw;

require Exporter;
require Tab::Text;
require Tab::AminoAcids;

use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&SemiGlobal);

use vars       qw(@tmp);

sub SmithWaterman {
    # set defaults
    (@SeqI,@SeqJ) = ();
    $tmpScore=0;
    %args = (
	     SEQI       => "",
	     SEQJ       => "",
	     MATRIX     => "",
	     GAP        => -12,
	     SENSITIVITY=>  0.4,
	     LPR_MATRIX =>  0,
	     LPR_SEQ    =>  0,
	     LPR_ALIGN  =>  0,
	     LPR_SCORE  =>  0,
	     @_
	     );

    &seq_info;
    &set_score_matrix;
    @maxCoordinates = &find_max_score;
    print "Coordinates: @maxCoordinates\n",
          $score[$maxCoordinates[0]][$maxCoordinates[1]],"\n";
    &align($maxCoordinates[0],$maxCoordinates[1],$alLen);
    &print_align;
    &print_score;

    return $tmpScore;
}







########################################################
#            Non Exported Functions                    #
########################################################

# get sequence info and print (if applicable)
sub seq_info {
    $len1 = length($seqI);
    $len2 = length($seqJ);
    @seqI = &Tab::Text::GetC( $args{SEQI} );
    @seqJ = &Tab::Text::GetC( $args{SEQJ} );
    &print_seq_info;
}

# set score matrix
sub set_score_matrix {
    for $i (0..length( $args{SEQI} )+1) {
	$score[$i][0] = $i*0;
    }
    for $j (0..length( $args{SEQJ} )+1) {
	$score[0][$j] = $j*0;
    }
    for $i (1..length( $args{SEQI} )) { 
	for $j (1..length( $args{SEQJ} )) { 
	    $score[$i][$j] = &max; 
	}
    }
    if ($args{LPR_MATRIX} == 1) {
	&print_matrix;
    }
}

# Determine highest score for 3 combinations
sub max {
    $val1 = $score[$i-1][$j] + $args{GAP};  
    $val3 = $score[$i][$j-1] + $args{GAP};
    $val2 = $score[$i-1][$j-1] + &match($i,$j);
#    print $i, $j,"\n";;
#    print $seqI[$i], $seqJ[$j];
    ($val1>$val2) ? $tmpMax=$val1 : $tmpMax=$val2;
    ($val3>$tmpMax) ? $tmpMax=$val3 : $tmpMax=$tmpMax;
    return $tmpMax;
}

# Get score for diagonal match
sub match {
    my ($a,$b) = ();
    my $a = $_[0];
    my $b = $_[1];

    &load_score_matrix;
#    print "$seqI[$a-1] eq $seqJ[$b-1] score 
#           $matrixHash{$seqI[$a-1]}{$seqJ[$b-1]}\n";
#    print $matrixHash{$seqI[$a-1]}{$seqJ[$b-1]}, "\n";
    return $matrixHash{$seqI[$a-1]}{$seqJ[$b-1]};
}

# load scoring matrix into hash
sub load_score_matrix {
    my ($tmp1,$tmp2);
   open (MATRIX, "$args{MATRIX}") || die "SW Error:\nCouldn't open matrix";
    while (<MATRIX>) {
	$_ = m/([A-Z]{3})\s+([A-Z]{3})\s+(\d\.\d)/;
	$tmp1 = $Tab::AminoAcids::Amino{$1};
	$tmp2 = $Tab::AminoAcids::Amino{$2};
	$matrixHash{$tmp1}{$tmp2}=$3;
	$matrixHash{$tmp2}{$tmp1}=$3;
    }    
}
# find biggest value in last row/column
sub find_max_score {
    my $tmpScores=-10000;
    my @coordinates=();

    # horizontal
    for $j (0..length( $args{SEQJ}) ) {
	for $k (0..length( $args{SEQI}) ) {
	    if ($score[$k][$j] >= $tmpScores) {
		$tmpScores = $score[$k][$j];
		$coordinates[0] = $k;
		$coordinates[1] = $j;
	    }
	}  
    }

    # horizontal
#    for $j (0..length( $args{SEQJ}) ) {
#	if ($score[length( $args{SEQI} )][$j] >= $tmpScores) {
#	     $tmpScores = $score[length( $args{SEQI} )][$j];
#	     $coordinates[0] = length( $args{SEQI} );
#	     $coordinates[1] = $j;
#	 }
#    }
#    # vertical
#    for $j (0..length( $args{SEQI}) ) {
#	if ($score[$j][length( $args{SEQJ} )] >= $tmpScores) {
#	     $tmpScores = $score[$j][length( $args{SEQJ} )];
#	     $coordinates[0] = $j;
#	     $coordinates[1] =  length( $args{SEQJ} );
#	 }
#     }
    #print "MAXSCORE: $tmpScore\n";
    return @coordinates;
}

# Align the optimal sequence
sub align {
    my $i = $_[0];
    my $j = $_[1];
  
#   print "i: $i\n";
#   print "j: $j score:$score[$i][$j] \n";
    $tmpScore += $score[$i][$j];

    if ($i==0) {
	if ($j==0) {
	    $alLen = 0;
	} elsif ($score[$i][$j] == $score[$i][$j-1]+$args{GAP} ) {     
#	    print "in hizzer";
	    $alI[$alLen] = "*";
	    $alJ[$alLen] = $seqJ[$j-1];
	    $alLen++;
	    &align($i, $j-1, $alLen);
	} 
    } elsif ($i>0) {
#	print "in i>0\n";
#       print "$score[$i][$j] == ", $score[$i-1][$j]+$args{GAP},"\n";
	if ($score[$i][$j] == $score[$i-1][$j]+$args{GAP} ) {
#	    print "up\n";
	    $alI[$alLen] = $seqI[$i-1];
	    $alJ[$alLen] = "*";
	    $alLen++;
	    &align($i-1, $j, $alLen);
	} elsif ($j>0) {
	#    print "in j>0\n";
	    $tmpMatch = &match($i,$j);
	 #   print "tmpmatch = $tmpMatch\n";
         #   print "$score[$i][$j] == ", $score[$i-1][$j-1]+$tmpMatch,"\n";
	    if($score[$i][$j] == $score[$i-1][$j-1]+$tmpMatch ) {
#		print "diagonal\n";
		$alI[$alLen] = $seqI[$i-1];
		$alJ[$alLen] = $seqJ[$j-1];
		#print $alI[$alLen], "\n";
		#print $alJ[$alLen], "\n";
		$alLen++;
		&align($i-1, $j-1, $alLen);

	    } elsif ($score[$i][$j] == $score[$i][$j-1]+$gap ) {     
		$alI[$alLen] = "*";
		$alJ[$alLen] = $seqJ[$j-1];
		$alLen++;
#		print "done3\n";
		&align($i, $j-1, $alLen);
	    }
	}
    }
}

##############################################################
#              Printing SubRoutines                          #
##############################################################
sub print_seq_info {
    # print to STDOUT
    if ($args{LPR_SEQ}==1) {
	print "Sequences\n";
	print "-------------\n";
	print @seqI, "\n", @seqJ, "\n";
    }
}

# Print Aligment Matrix STDOUT
sub print_matrix {
    print "\n\n";
    print "Alignment Array\n";
    print "---------------\n";
    print "          ";
    foreach (@seqJ) {
	printf("%5s", $_); 
    }
    print "\n","     ";
    
    for $i (0..length( $args{SEQI} )) {  
	for $j (0..length( $args{SEQJ} )) { 
	    printf("%5.1f", $score[$i][$j]); 
	} 
	print "\n";    
	printf("%5s",$seqI[$i]);
    }
    print "\n";
}

sub print_align {
    if ($args{LPR_ALIGN}==1) {
	print "\n";
	print "Opitimal Alignment\n";
	print "------------------\n";
	@alJ = reverse @alJ;
	@alI = reverse @alI;
	print @alJ, "\n";
	&pairwise; print "\n";
	print @alI, "\n";
    }
}    

sub pairwise {
    for $i (0..$#alI) {
#	print $alJ[$i], $alI[$i],"\n";
#	print $matrixHash{$alJ[$i]}{$alI[$i]}, "\n";
	if ($matrixHash{$alJ[$i]}{$alI[$i]} > $args{SENSITIVITY}) {
	    print "+";
	} else {
	    print " ";
	}
    }
}

sub print_score {
    if ($args{LPR_SCORE}==1) {
	print "\n\nScore\n-----\n$tmpScore\n\n";
    }
}


END { }      

1;



