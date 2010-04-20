package Sling::AminoAcids;

require Exporter;

@ISA         = qw(Exporter);
@EXPORT      = qw(%AminoAcids %AminoAcids1To3);

use vars       qw(%AminoAcids %AminoAcids1To3);

%AminoAcids   = ( "GLY", "G", "ALA", "A", "VAL", "V", "LEU", "L",
		  "ILE", "I", "SER", "S", "THR", "T", "CYS", "C",
		  "MET", "M", "MSE", "M",
		  "PRO", "P", "ASP", "D", "ASN", "N",
		  "GLU", "E", "GLN", "Q", "LYS", "K", "ARG", "R",
		  "HIS", "H", "PHE", "F", "TYR", "Y", "TRP", "W"
		  );
%AminoAcidsHydrophobicity = (
			"ALA"=>"0","ARG"=>"0","ASN"=>"0","ASP"=>"0",       
			"CYS"=>"1","GLN"=>"0","GLU"=>"0","GLY"=>"0",
			"HIS"=>"0","ILE"=>"1","LEU"=>"1","LYS"=>"0",         
			"MET"=>"1","PHE"=>"1","PRO"=>"0","SER"=>"0",         
			"THR"=>"0","TRP"=>"1","TYR"=>"0","VAL"=>"1");

%AminoAcids1To3   = ( "G","GLY",
		      "A","ALA", 
		      "V","VAL",
		      "L","LEU",
		      "I","ILE",
		      "S","SER",
		      "T","THR",
		      "C","CYS",
		      "M","MET",
		      "P","PRO",
		      "D","ASP",
		      "N","ASN",
		      "E","GLU",
		      "Q","GLN",
		      "K","LYS",
		      "R","ARG",
		      "H","HIS",
		      "F","PHE",
		      "Y","TYR",
		      "W","TRP"
		      );

END {}
1;























