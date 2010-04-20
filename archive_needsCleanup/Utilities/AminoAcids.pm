package Utilities::AminoAcids;

use strict;

require Exporter;
use vars       qw($VERSION @ISA @EXPORT);

$VERSION     = 0.01;
@ISA         = qw(Exporter);
@EXPORT      = qw(%Amino);

use vars       qw(%Amino);

%Amino   = ( "GLY", "G", "ALA", "A", "VAL", "V", "LEU", "L",
	     "ILE", "I", "SER", "S", "THR", "T", "CYS", "C",
	     "MET", "M", "PRO", "P", "ASP", "D", "ASN", "N",
	     "GLU", "E", "GLN", "Q", "LYS", "K", "ARG", "R",
	     "HIS", "H", "PHE", "F", "TYR", "Y", "TRP", "W"
	   );

END { }

1;



