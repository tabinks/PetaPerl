package Discovery::OpenEye;

use Discovery::Configure;
use Switch;

####################################################################
## OpenEyeSmilesToMolecularProperties
####################################################################
sub OpenEyeSmilesToMolecularProperties {

    my ($smiles,$id,$mode) = @_;
    #my $tmpFile = $CFG{'TMP'}."/openEye.pinfo";
    my $tmpFile = "openEye.pinfo";
    my $returnString = '';

    if ($smiles ne '') {
	## Calculate properties
	`echo "$smiles $id" | $CFG{'OE_FILTER'} -in .smi -out .smi -table $tmpFile`;
	
	switch($mode) {
	    case "ALL" {@filter = (0..173) }
	    case "ELEMENTAL" {@filter = (0,2..16,174..188) }
	    case "FUNCTIONAL" {@filter = (17..173) }
	}
	
	my @pinfoFile = Utilities::File::FileToArray($tmpFile);
	my @headers = split /\t/,shift @pinfoFile;
	
	for ($i=0;$i<=$#pinfoFile;$i++) {
	    $returnString .= "   <molecularProperties>\n";
	    chomp($pinfoFile[$i]);
	    @line = split /\t/,$pinfoFile[$i];
	    
	    for ($z=0;$z<=$#filter;$z++) {
		$tmpHeader = Utilities::String::StringUnderscore(lc($headers[$filter[$z]]));
		$tmpHeader =~ s/\-/_/g;
		$returnString .= "    <oe_".$tmpHeader.">".$line[$filter[$z]]."</oe_".$tmpHeader.">\n";
	    }
	    $returnString .= "   </molecularProperties>\n";
	}
	
	## Clean up
#   `rm $tmpFile`;
#   `rm filter.*`;
	return $returnString;
    }
}

####################################################################
## OpenEyeSmilesToImg
####################################################################
sub OpenEyeSmilesToImg {
    
    my ($smiles,$id,$outputPath) = @_;
    #my $tmpFile = $CFG{'TMP'}."/openEyeSmilesToImg.smi";
    my $tmpFile = "openEyeSmilesToImg.smi";
    my $outFile = "$outputPath/$id.gif";

    if (!-e $outFile && $smiles ne '') {
	open (FILE,"> $tmpFile") or die "OpenEyeSmilesToImg: Couldn't open $tmpFile: $!\n";
	print FILE "$smiles\n";
	close FILE;
	
	#`$CFG{'MOL2GIF'} -scale 1.50 -cob -aromcirc -verbose -trans $tmpFile $outFile`;
	`$CFG{'MOL2GIF'} -aromcirc -cob -verbose -trans $tmpFile $outFile`;
	#`$CFG{'MOL2GIF'} -aromcirc -scale .75 -trans $tmpFile $outFile`;
	`rm $tmpFile`;
    } else {
	print STDERR "Discovery::OpenEye::OpenEyeSmilesToImg - $outFile already exists\n";
    }
}
END {}
1;
