package Discovery::OpenBabel;

use Discovery::Configure;

sub OpenBabelSdf2Smi {
    
    my ($dbFile,$outFile) = @_;
    my $tmpFile = $CFG{'TMP'}."/openEyeSmilesToImg.smi";
    my $outFile = "$ouputPath/$id.gif";

    open (FILE,"> $tmpFile") or die "OpenEyeSmilesToImg: Couldn't open $tmpFile: $!\n";
    print FILE "$smiles\n";
    close FILE;
    
    `$CFG{'MOL2IMG'} $tmpFile $outFile`;
    `rm $tmpFile`;
}
END {}
1;
