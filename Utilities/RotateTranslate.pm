package Utilities::RotateTranslate;

use Sling::Trim;

#############################################################
# ArrayUnique
#
#############################################################
sub TranslateToCenterOfMass {
    my ($cogX,$cogY,$cogZ,@coords) = @_;
    my @return = ();
    
    foreach (@coords) {
	next if $_=~/^$/;
	$oldX = substr($_,31,7);
	$oldY = substr($_,39,7);
	$oldZ = substr($_,47,7);
	$line = $_;
	#print $_;
	substr($line,31,7) = sprintf("%7.3f",$oldX-$cogX);
	substr($line,39,7) = sprintf("%7.3f",$oldY-$cogY);
	substr($line,47,7) = sprintf("%7.3f",$oldZ-$cogZ);
	#print "\t".$line;
	push @return, $line;
    }
    return @return;
}
sub RotateCoordsArrayByRotationMatrix {
    my ($rotationMatrixString,@coords) = @_;
    my @return = ();
    
    foreach (@coords) {
	$x = substr($_,31,7);
	$y = substr($_,39,7);
	$z = substr($_,47,7);
	@a = RotateXYZByRotationMatrix($x,$y,$z,$rotationMatrixString);
	$line = $_;
	substr($line,31,7) = sprintf("%7.3f",$a[0]);
	substr($line,39,7) = sprintf("%7.3f",$a[1]);
	substr($line,47,7) = sprintf("%7.3f",$a[2]);
	push @return, $line;
    }
    return @return;
}

sub RotateXYZByRotationMatrix {
 
    my ($x,$y,$z,$rotationMatrixString) = @_;
    my @returnArray = ();

    @coords = split /,/,$rotationMatrixString;

    #print "IN: $x $y $z\n";
    $returnArray[0] = ($x*$coords[0]) + ($y*$coords[3]) + ($z*$coords[6]);
    $returnArray[1] = ($x*$coords[1]) + ($y*$coords[4]) + ($z*$coords[7]);
    $returnArray[2] = ($x*$coords[2]) + ($y*$coords[5]) + ($z*$coords[8]);
    #print "OUT: $returnArray[0] $returnArray[1] $returnArray[2]\n";
    return @returnArray;
}

END {}
1;
