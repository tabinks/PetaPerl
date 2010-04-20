package Sling::PocketArray;

use Utilities::File;
use Sling::Configure;
use Sling::PdbParse;
use Sling::PocketLoad;
use Sling::PdbStripDNA;

$DEBUG=0;

#####################################################################################
# PocketArray
#
# Description: Returns an array of ATOM lines from a given PDB,POCKETID, and DIR
#
#####################################################################################
sub PocketArrayStripHeteroAtoms {
    
    my @pocketArray = @_;
    my @return = ();

    foreach (@pocketArray) {
	next unless $_ =~ /^ATOM/;
	push(@return, $_);
    }
    return @return;
}

sub PocketArray {
    
    my ($PDB,$POCKETID,$DIR) = @_;
    my @return = ();

    @pocFile = Utilities::File::FileToArray($DIR.'/'.substr($PDB,1,2).'/'.$PDB.'.poc');
    foreach (Sling::PdbStripDNA::PdbStripDNA(@pocFile)) {
	next unless $_ =~ /^ATOM/;
	if (Sling::PdbParse::PdbParse_Pocket($_) == $POCKETID) {
	    if ($DEBUG) {
		print $_;
		print Sling::PdbParse::PdbParse_Pocket($_)." ".$POCKETID."\n";
	    }
	    push(@return, $_."\n");
	}
    }
    return @return;
}

sub PocketArrayWithAllAtoms {
    
    my ($PDB,$DIR) = @_;
    my @return = ();

    @pocFile = Utilities::File::FileToArray($DIR.'/'.substr($PDB,1,2).'/'.$PDB.'.poc',"nice");
    foreach (Sling::PdbStripDNA::PdbStripDNA(@pocFile)) {
	next unless $_ =~ /^ATOM/;
	push(@return, $_."\n");
    }
    return @return;
}

sub PocketArrayWithHeteroAtoms {
    
    my ($PDB,$POCKETID,$DIR) = @_;
    my @return = ();

    @pocFile = Utilities::File::FileToArray($DIR.'/'.substr($PDB,1,2).'/'.$PDB.'.poc',"nice");
    foreach (@pocFile) {
	next unless $_=~/^[ATOM|HETATM]/;
	if (Sling::PdbParse::PdbParse_Pocket($_) == $POCKETID) {
	    push(@return, $_."\n");
	}
    }
    return @return;
}

#####################################################################################
# PocketArrayRename Chain
#
# Description: Returns an array wiht new chain
#
#####################################################################################
sub PocketArrayRenameChain {
    
    my ($chain,@pocketArray) = @_;
    my @return = ();
    
    foreach $line (@pocketArray) {
	substr($line,21,1) = $chain;
	push @return, $line;
    }


    return @return;
}

#####################################################################################
# PocketArrayCofG
#
# Description: Returns an array of ATOM lines from a given PDB,POCKETID, and DIR
#
#####################################################################################
sub PocketArrayCofG {
    
    my (@queryPocketArray) = @_;
    my @coords = ();

    $qCogX = $qCogY = $qCogZ = $qCount = 0;
    
    foreach (@queryPocketArray) {
	$coords[0] += substr($_,31,7);
	$coords[1] += substr($_,39,7);
        $coords[2] += substr($_,47,7);
        $qCount++;
    }
    $coords[0] /= $qCount;
    $coords[1] /= $qCount;
    $coords[2] /= $qCount;

    return @coords;
}

sub PocketArrayCofG2 {
    
    my ($PDB,$POCKETID,$DIR,$CHAIN) = @_;
    $qCogX = $qCogY = $qCogZ = $qCount = 0;
    $sCogX = $sCogY = $sCogZ = $sCount = 0;    

    @queryPocketArray = PocketArray($PDB,$POCKETID,$DIR);
    
    foreach (@queryPocketArray) {
	$line = $_;
	substr($line,21,1) = $CHAIN; # Chain
	$qCogX += substr($_,31,7);
	$qCogY += substr($_,39,7);
        $qCogZ += substr($_,47,7);
        print "$qCount: $line";
        $qCount++;
        push @queryArray, $line;
    }
    print "Query CoG: $qCogX $qCogY $qCogZ $qCount;\n";
    $qCogX /= $qCount;
    $qCogY /= $qCount;
    $qCogZ /= $qCount;
    print "Query CoG: $qCogX $qCogY $qCogZ\n";
}

END {}
1;
k
