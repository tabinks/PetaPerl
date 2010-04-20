package Sling::PdbLineByAtom;

use Sling::Configure;

sub PdbLineByAtom {
    
    my $atomNumber = shift @_;
    my @pdbFile = @_;

    my $string = '';
    
    foreach (@pdbFile) {
        next unless $_=~/^ATOM|^HETATM/;  # some remarks, etc. have numbers after them
        if ($atomNumber == substr($_,6,5)) {
            $string = substr($_,0,66);
            $string .="   1  POC\n";
            return $string;
        }
    }
}
        
END {}
1;
