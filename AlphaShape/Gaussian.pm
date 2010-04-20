package AlphaShape::Gaussian;

use Sling::Configure;
use Sling::PdbParse;
use Utilities::Hash;
use Utilities::Trim;
use Utilities::File;
use Utilities::Debug;

$DEBUG=1;
$KAPPA =  3.1415927 / 1.5514**(2/3);
#$KAPPA = 2.7;
$PI = 3.1415927;

my %alpha = ("C" => $KAPPA/1.70**2,
	     "N" => $KAPPA/1.65**2,
	     "H" => $KAPPA/1.00**2,
	     "O" => $KAPPA/1.60**2,
	     "S" => $KAPPA/1.90**2,
	     "P" => $KAPPA/1.90**2,
	     "F" => $KAPPA/1.30**2);

my %sigma = ("C" => 1.70,
	     "N" => 1.65,
	     "H" => 1.00,
	     "O" => 1.60,
	     "S" => 1.90,
	      "P" => 1.90,
	     "F" => 1.30);


sub GaussianVolume2002 {
    
    my $atomCount=0;
    my $prod=1;
    
    my ($d,$d2) = @_;
    my @data = @$d;
    my @data2 = @$d2;
    my $xi,$yi,$zi,$ri,$vi;
    my $xj,$yj,$zj,$rj,$vj;
    my $a,$b,$c,$vij,$distance;
    my $viSum=0;
    my $vijSum=0;
    my $vij2=$vijSum=0;

    foreach (my $i=0; $i<=$#data+1; $i++) {

	## Total sphere volume (including overlaps)
	next if $data[$i]!~/ATOM/;
	$atomNumberi = Utilities::Trim::Trim(substr($data[$i],22,4));  # ATOM only taking 1st letter 
	$xi = Utilities::Trim::Trim(substr($data[$i],31,7));  # X
	$yi = Utilities::Trim::Trim(substr($data[$i],39,7));  # Y
	$zi = Utilities::Trim::Trim(substr($data[$i],47,7));  # Z 
	$ai = Utilities::Trim::Trim(substr($data[$i],12,2));  # ATOM only taking 1st letter 
	$ri = $sigma{$ai}; # radius
	$vi = (4/3) * $PI * ($ri**3); # sphere volume
	#$vi = (4/3) * ($KAPPA**3/$PI)**(1/2) * exp((-1*$KAPPA/$ri**2) * $ri**2); # sphere volume
	$viSum += $vi;
	Utilities::Debug::Debug($DEBUG,"$i: $ai:$atomNumberi [$ri] $vi\n");
	
	## Overlap Volume
	foreach ($j=$i+1; $j<=$#data2; $j++) {
	    next if $data2[$i]!~/ATOM/;
	    $atomNumberj = Utilities::Trim::Trim(substr($data2[$j],22,4));  # atomNumber
	    $xj = Utilities::Trim::Trim(substr($data2[$j],31,7));  # X
	    $yj = Utilities::Trim::Trim(substr($data2[$j],39,7));  # Y
	    $zj = Utilities::Trim::Trim(substr($data2[$j],47,7));  # Z 
	    $aj = Utilities::Trim::Trim(substr($data2[$j],12,2));  # ATOM only taking 1st letter 
	    $rj = $sigma{$aj};
	    
	    $distance = sqrt( ($xi-$xj)**2 + ($yi-$yj)**2 + ($zi-$zj)**2);
	    #Utilities::Debug::Debug($DEBUG,sprintf(" %s%d-%s%d | dist:%3.2f \n",$ai,$atomNumberi,$aj,$atomNumberj,$distance));
	    if ($distance <= $rj+$ri) {
		$a = (16*$KAPPA**3) / (9*$PI);
		$b = (($PI * $ ri**2 * $rj**2) / ($KAPPA*($ri**2) + $KAPPA*($rj**2)))**1.5;
		$c = exp(-1*$KAPPA/($ri**2 + $rj**2) * $distance**2);
		$vij = $a * $b * $c;
		$vijSum += $vij;
		Utilities::Debug::Debug($DEBUG,sprintf("   %s%d-%s%d | dist:%3.2f | a:%3.2f b:%3.2f c:%3.2f =  vij:%3.2f | viSum:%3.2f vijSum:%3.2f\n", 
						       $ai,$atomNumberi,$aj,$atomNumberj,$distance,$a,$b,$c,$vij,$viSum,$vijSum));
	    }
	}
    }
    print ">>> $viSum - $vijSum\n";;
    return $viSum - $vijSum;
    #return $vijSum; # Difference only
}

sub GaussianVolume1996 {
    
    my $atomCount=0;
    my $prod=1;
    
    my ($d,$d2) = @_;
    my @data = @$d;
    my @data2 = @$d2;
    my $xi,$yi,$zi,$ri,$vi;
    my $xj,$yj,$zj,$rj,$vj;
    my $a,$b,$c,$vij,$distance;
    my $viSum=0;
    my $vijSum=0;
    my $vij2=$vijSum=0;

    foreach (my $i=0; $i<=$#data+1; $i++) {

	## Total sphere volume (including overlaps)
	next if $data[$i]!~/ATOM/;
	$atomNumberi = Utilities::Trim::Trim(substr($data[$i],22,4));  # ATOM only taking 1st letter 
	$xi = Utilities::Trim::Trim(substr($data[$i],31,7));  # X
	$yi = Utilities::Trim::Trim(substr($data[$i],39,7));  # Y
	$zi = Utilities::Trim::Trim(substr($data[$i],47,7));  # Z 
	$ai = Utilities::Trim::Trim(substr($data[$i],12,2));  # ATOM only taking 1st letter 
	$ri = $sigma{$ai}; # radius
	$vi = (4/3) * $PI * ($ri**3); # sphere volume
	#$vi = (4/3) * ($KAPPA**3/$PI)**(1/2) * exp((-1*$KAPPA/$ri**2) * $ri**2); # sphere volume
	$viSum += $vi;
	Utilities::Debug::Debug($DEBUG,"$i: $ai [$ri] $vi\n");
	
	## Overlap Volume
	foreach ($j=$i+1; $j<=$#data2; $j++) {
	    next if $data2[$i]!~/ATOM/;
	    $atomNumberj = Utilities::Trim::Trim(substr($data2[$j],22,4));  # ATOM only taking 1st letter 
	    $xj = Utilities::Trim::Trim(substr($data2[$j],31,7));  # X
	    $yj = Utilities::Trim::Trim(substr($data2[$j],39,7));  # Y
	    $zj = Utilities::Trim::Trim(substr($data2[$j],47,7));  # Z 
	    $aj = Utilities::Trim::Trim(substr($data2[$j],12,2));  # ATOM only taking 1st letter 
	    $rj = $sigma{$aj};
	    
	    $distance = sqrt( ($xi-$xj)**2 + ($yi-$yj)**2 + ($zi-$zj)**2);
	    if ($distance <= $rj+$ri) {
		$kij = exp( (-1 * $alpha{$ai} * $alpha{$aj} * $distance**2) / 
			    ($alpha{$ai} + $alpha{$aj})
			    );
		
		$vij = (2.7*2.7) * $kij * ($PI/($alpha{$ai}+$alpha{$aj}))**(3/2);
		$vijSum += $vij;
		Utilities::Debug::Debug($DEBUG,sprintf("   %s%d-%s%d | dist:%3.2f | a:%3.2f b:%3.2f c:%3.2f vij:%3.2f | kij:%3.2f vij2:%3.2f\n", 
						       $ai,$atomNumberi,$aj,$atomNumberj,$distance,$a,$b,$c,$vij,$kij,$vij2));
	    }
	}
	#print "\n";
    }
    print ">>> $viSum - $vijSum\n";;
    return $viSum - $vijSum;
    #return $vijSum;
}


END {}
1;
