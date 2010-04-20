package Sling::SurfaceDistribution;

use Sling::Configure;
use Utilities::Array;
use Utilities::Trim;

$DEBUG=1;
$BINS=50;
$normalize=0;

################################################################
# SurfaceDistance()
#    
# Date: 9/20/2006

# Returns a sorted array of the surface distance between all
# atoms included in the array
#
# Usage: SurfaceDistanceRaw(0,@pocketArray)
#
################################################################
sub SurfaceDistanceRaw {
    
    my ($scale,@surfaceArray) = @_;
    my @bins=();
    my $distanceMax = 0;
    my @distanceArray = ();
    
    foreach ($i=0; $i<$#surfaceArray; $i++) {
	$xi = Utilities::Trim::Trim(substr($surfaceArray[$i],31,7));  # X
	$yi = Utilities::Trim::Trim(substr($surfaceArray[$i],39,7));  # Y
	$zi = Utilities::Trim::Trim(substr($surfaceArray[$i],47,7));  # Z
	
	foreach ($j=$i+1; $j<$#surfaceArray; $j++) {
	    $xj = Utilities::Trim::Trim(substr($surfaceArray[$j],31,7));  # X
	    $yj = Utilities::Trim::Trim(substr($surfaceArray[$j],39,7));  # Y
	    $zj = Utilities::Trim::Trim(substr($surfaceArray[$j],47,7));  # Z
	    $distance = sqrt( ($xi-$xj)**2 + ($yi-$yj)**2 + ($zi-$zj)**2);
	    $distanceMax = $distance > $distanceMax ? $distance : $distanceMax;
	    push @distanceArray, sprintf("%.3f",$distance);
	}
    }
    if ($scale) {
	#Normalized...not scaled
	foreach (@distanceArray) { push @distanceNormalizedArray, $_/$distanceMax; }
	return sort {$a<=>$b} @distanceNormalizedArray;
    } else {
	return sort {$a<=>$b} @distanceArray;
    }
}

###############################################################################
# SurfaceDistribution
#
###############################################################################
sub SurfaceDistributionNorm {

    my (@surfaceArray) = @_;
    my @bins=();
    my $distanceMax = 0;
    my $distanceMean = 0;
    my $count = 0;

    for ($i=0;$i<$BINS;$i++) {
	$bins[$i]=0;
    }
    
    foreach ($i=0; $i<$#surfaceArray; $i++) {
	#print "$i = $surfaceArray[$i]";
	$xi = Utilities::Trim::Trim(substr($surfaceArray[$i],31,7));  # X
	$yi = Utilities::Trim::Trim(substr($surfaceArray[$i],39,7));  # Y
	$zi = Utilities::Trim::Trim(substr($surfaceArray[$i],47,7));  # Z
	
	@distanceArray=();
	$count=0;
	foreach ($j=$i+1; $j<$#surfaceArray; $j++) {
	    #print "\t==$surfaceArray[$j]";
	    $xj = Utilities::Trim::Trim(substr($surfaceArray[$j],31,7));  # X
	    $yj = Utilities::Trim::Trim(substr($surfaceArray[$j],39,7));  # Y
	    $zj = Utilities::Trim::Trim(substr($surfaceArray[$j],47,7));  # Z
	    $distance = sqrt( ($xi-$xj)**2 + ($yi-$yj)**2 + ($zi-$zj)**2);
	    $distanceMax = $distance > $distanceMax ? $distance : $distanceMax;
	    $distanceMean += $distance;
	    $count++;
	    push @distanceArray, $distance;
	}
	#$distanceMean /= $count;
	#print "distanceMean: $distanceMean\n";

	foreach (@distanceArray) {
	    $distNorm = ($_/$distanceMax) * 100;
	    #$distNorm = ($_/$distanceMean) * 100;
	    $index = round($distNorm)/4;
	    #print "$distNorm $index \n";
	    $bins[$index]++;
	}
    }
    #Utilities::Array::ArrayPrintToStderr($DEBUG,sort {$a<=>$b} @bins);
    return @bins;
}

###################################################################################
#
###################################################################################
sub KS {
    
    my ($scaled,$qRef,$lRef) = @_;
    %return = ();
    
    $fn1=$fn2=$dt=0.0;
    if ($scaled) {
	@data1 = SurfaceDistanceRaw(1,@{$qRef});
	@data2 = SurfaceDistanceRaw(1,@{$lRef});
    } else {
	@data1 = SurfaceDistanceRaw(0,@{$qRef});
	@data2 = SurfaceDistanceRaw(0,@{$lRef});
    }
    #unshift(@data1,'-10000');
    #unshift(@data2,'-10000');
    #unshift(@data1,'0');
    #unshift(@data2,'0');

    $n1=$#data1;
    $n2=$#data2;
    $en1=$n1;
    $en2=$n2;
    $j1=$j2=1;
    $d=0.0;
    $prob = 0.0;

    #Utilities::Array::ArrayPrintToFile("SurfaceDistribution::KS::query.dat",@data1);
    #Utilities::Array::ArrayPrintToFile("SurfaceDistribution::KS::library.dat",@data2);

    while ($j1<=$n1 && $j2<=$n2) {
	$d1=$data1[$j1];
	$d2=$data2[$j2];

	if ($d1 <= $d2) { 
	    $fn1=$j1++/$en1; 
	}
	if ($d2<=$d1) { 
	    $fn2=$j2++/$en2; 
	}
	if (($dt=abs($fn2-$fn1)) > $d) { 
	    $d=$dt;
	}
	#printf("%f %f |  %f -  %f  = %f\n",$d1,$d2,$fn1,$fn2,$d);
    }
    #$en=sqrt($en1*$en2/($en1+$en2));
    #$prob = probks(($en+0.12+0.11/$en)*$d);
    #printf("KS: d:%f prob: %e\n",$d,$prob);
    $return{'DISTANCE'} = $d;
    $return{'PROBABILITY'} = $prob;
    push @{$return{'DATA1'}},@data1;
    push @{$return{'DATA2'}},@data2;
    return %return;
}

###################################################################################
# KS
#
#
###################################################################################
sub KSthisWasForBinnedData {
    
    my ($qRef,$lRef) = @_;
    my @data1 = sort {$a<=>$b} @{$qRef};
    my @data2 = sort {$a<=>$b} @{$lRef};
    my %return = ();
    
    unshift(@data1,'-10000');
    unshift(@data2,'-10000');

    my $fn1=$fn2=$dt=0.0;
    my $n1=$#data1;
    my $n2=$#data2;
    my $en1=$n1;
    my $en2=$n2;
    my $j1=$j2=1;
    my $d=0.0;
    my $prob = 0.0;

    #Utilities::Array::ArrayPrintToStderr("zDat1",@data1);
    #print "\n\n";
    #Utilities::Array::ArrayPrintToStderr("zDat1",@data2);

    #Utilities::Array::ArrayPrintToStderr("zDat1",@data2);
    #Utilities::Array::ArrayPrintToFile("zDat1",@data1);
    #Utilities::Array::ArrayPrintToFile("zDat2",@data2);

    while ($j1<=$n1 && $j2<=$n2) {
	#printf("%d - %d | ",$j1,$j2);
	$d1=$data1[$j1];
	$d2=$data2[$j2];

	if ($d1 <= $d2) { 
	    $fn1=$j1++/$en1; 
	}
	if ($d2<=$d1) { 
	    $fn2=$j2++/$en2; 
	}
	if (($dt=abs($fn2-$fn1)) > $d) { 
	    $d=$dt;
	}
	#printf("%f %f |  %f -  %f = %f | %f | %f %f\n",$d1,$d2,$fn2,$fn1,abs($fn2-$fn1),$d,$j1,$j2);
    }
    $en=sqrt($en1*$en2/($en1+$en2));

    $prob = probks(($en+0.12+0.11/$en)*$d);
    #printf("KS: d:%f prob: %e\n",$d,$prob);
    $return{'DISTANCE'} = $d;
    $return{'PROBABILITY'} = $prob;
    $return{'DATA1'} = @data1;
    $return{'DATA2'} = @data2;
    return %return;
}

###################################################################################
#
###################################################################################
sub KSold {
    
    my ($normalized,$qRef,$lRef) = @_;
    %return = ();
    
    $fn1=$fn2=$dt=0.0;
    if ($normalized) {
	@data1 = SurfaceDistanceRaw(1,@{$qRef});
	@data2 = SurfaceDistanceRaw(1,@{$lRef});
    } else {
	@data1 = SurfaceDistanceRaw(0,@{$qRef});
	@data2 = SurfaceDistanceRaw(0,@{$lRef});
    }
    $n1=$#data1;
    $n2=$#data2;
    $en1=$n1;
    $en2=$n2;
    $j1=$j2=0;
    $d=0.0;
    $prob = 0.0;

    #Utilities::Array::ArrayPrintToFile("zDat1",@data1);
    #Utilities::Array::ArrayPrintToFile("zDat2",@data2);

    while ($j1<=$n1 && $j2<=$n2) {
	$d1=$data1[$j1];
	$d2=$data2[$j2];

	if ($d1 <= $d2) { 
	    $fn1=$j1++/$en1; 
	}
	if ($d2<=$d1) { 
	    $fn2=$j2++/$en2; 
	}
	if (($dt=abs($fn2-$fn1)) > $d) { 
	    $d=$dt;
	}
	#printf("%f %f |  %f -  %f  = %f\n",$d1,$d2,$fn1,$fn2,$d);
    }
    $en=sqrt($en1*$en2/($en1+$en2));

    $prob = probks(($en+0.12+0.11/$en)*$d);
    #printf("KS: d:%f prob: %e\n",$d,$prob);
    $return{'DISTANCE'} = $d;
    $return{'PROBABILITY'} = $prob;
    $return{'DATA1'} = @data1;
    $return{'DATA2'} = @data2;
    return %return;
}

###################################################################################
# probks
# 
###################################################################################
sub probks {
    my $EPS1 = 1e-3;
    my $EPS2 = 1e-8;
    my $fac = 2.0;
    my $termbf = 0.0;
    my $term = 0;
    my $sum = 0;
    
    my ($alam) = @_;
    
    my $a2 = -2.0*$alam*$alam;
    
    for ($j=1;$j<=100;$j++) {
	$term = $fac*exp($a2*$j*$j);
	$sum += $term;
	if (abs($term) <= $EPS1*$termbf || abs($term)<=$EPS2*$sum) {
	return $sum;
	}
	$fac = $fac*-1;
	$termbf=abs($term);
    }
    return 1.0;
}

###################################################################################
# SurfaceDistribution
#     #sqrt (sum x**2 - N(meanX)**2 / (n-1))
###################################################################################
sub SurfaceDistribution {

    my ($scale,@surfaceArray) = @_;
    my @bins=();
    my $distanceMax = 0;
    my $mean=$sum=$sumSquared=$sd=0;
    
    # Clean bins
    for ($i=0;$i<$BINS;$i++) {
	$bins[$i]=0;
    }
    
    foreach ($i=0; $i<$#surfaceArray; $i++) {
	#print "$i = $surfaceArray[$i]";
	$xi = Utilities::Trim::Trim(substr($surfaceArray[$i],31,7));  # X
	$yi = Utilities::Trim::Trim(substr($surfaceArray[$i],39,7));  # Y
	$zi = Utilities::Trim::Trim(substr($surfaceArray[$i],47,7));  # Z
	
	
	foreach ($j=$i+1; $j<$#surfaceArray; $j++) {
	    $xj = Utilities::Trim::Trim(substr($surfaceArray[$j],31,7));  # X
	    $yj = Utilities::Trim::Trim(substr($surfaceArray[$j],39,7));  # Y
	    $zj = Utilities::Trim::Trim(substr($surfaceArray[$j],47,7));  # Z
	    $distance = sqrt( ($xi-$xj)**2 + ($yi-$yj)**2 + ($zi-$zj)**2);
	    $distanceMax = $distance > $distanceMax ? $distance : $distanceMax;
	    #$index = round($distance);
	    $index = round(log($distance)*10);
	    $bins[$index]++;
	    #print "\t==$surfaceArray[$j] $distance";
	}
    }
    
    # Scale (if you want to)
    if ($scale==1) {
	print "IN SCALE!!!!!!!!!!!!!!!!!!!!!!!!!";
	# Find mean
	for ($i=0;$i<$BINS;$i++) {
	    $mean += $bins[$i];
	    #print "$i:".$bins[$i]." ";
	    $sum += $bins[$i];
	    $sumSquared += $bins[$i]**2;
	}
	#print "\n";
	
	$mean /= $BINS;
	$s = sqrt(($sumSquared - ($BINS*$mean**2))/($BINS-1));
	#printf(">>>>>>>>>>>>>>>>>>>>>> %.3f %.3f %.3f\n",$mean,$sumSquared,$s);
	
	# Center
	for ($i=0;$i<$BINS;$i++) {
	    $bins[$i] -= $mean;
	    #printf("%.1f ",$bins[$i]);
	}
	#print "\n";
	# Scale
	for ($i=0;$i<$BINS;$i++) {
	    $bins[$i] /= $s;
	    #printf("%.3f ",$bins[$i]);
	}
	#print "\n";
    }
    return @bins;
}


sub round {
    my $number = shift;
    return int($number+.5 * ($number <=> 0));
}

sub SurfaceDistributionString {
    
    my ($name,@distribution) = @_;
    my $returnString = "$name";
    
    for ($i=0;$i<=$#distribution;$i++) {
	$returnString .= " ".sprintf("%.3f",$distribution[$i]);
	#printf("%.3f ",$distribution[$i])
    }
    #print "\n\n";
    return $returnString;
}

sub SurfaceDistributionMatrixRotate {
    
    my ($fileName,@array) = @_;

    $arraySize=$#array+1; # need to increment because of name in index[0]

    open(OUT,"> $fileName") or die "Couldn't open $fileName:$!\n";    

    foreach ($i=0;$i<=$arraySize;$i++) {
	@lineArray = split /\s+/,$array[$i];
	for ($j=0;$j<=$#lineArray;$j++) {
	    $r[$j][$i] = $lineArray[$j];
	}
    }
    
    # Print out in pretty R format
    foreach ($i=0;$i<=$BINS;$i++) {
	for ($j=0;$j<$arraySize;$j++) {
	    print OUT $r[$i][$j]."\t";
	}
	print OUT "\n";
    }
}

END {}
1;
