package Tab::Helix; 

use Tab::Parser;
use Tab::AminoAcids;

require Exporter;
use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&Build);

use vars       qw(%results $tmpChain %numChain $tmpResNum %tmpHelix $counter);

sub Build {
    my %args = (
		@_
		);
    $tmpChain = "";
    $tmpResNum = "";

    # Main
    open(PDB, "< $args{INPUT}") || die "Tab::Helix::Build Error:\n
                                        Could not open $args{INPUT}\n";
    while(<PDB>) {
	if ($_ =~ /^ATOM/) {

	    %results = &Tab::Parser::Pdb(
					 INPUT        => $_,
					 CHAIN_ID     => 1,
					 RESIDUE_NUM  => 1,
					 RESIDUE_NAME => 1
					 );

	    if ($results{CHAIN_ID} ne $tmpChain) {         # New helix
		$tmpChain = $results{CHAIN_ID};

		$tmpHelix{$tmpChain}{id} = $tmpChain;
		#$tmpHelix{$tmpChain}{seq} = "$Tab::AminoAcids::Amino{$results{RESIDUE_NAME}}";
		$tmpHelix{$tmpChain}{start} = $results{RESIDUE_NUM};

		$counter = 1;

	    } else {                                       # Same helix
		if ($results{RESIDUE_NUM} ne $tmpResNum) { # New 
			$tmpResNum = $results{RESIDUE_NUM};
			$tmpHelix{$tmpChain}{seq} .= "$Tab::AminoAcids::Amino{$results{RESIDUE_NAME}}";
			$counter++;
			$tmpHelix{$tmpChain}{num} = $counter;
                        $tmpHelix{$tmpChain}{end} = $results{RESIDUE_NUM};
		    }
	    }


	}
    }    

    $tmpHelix{$tmpChain}{num} = $counter;

    close PDB;

    return %tmpHelix;
}

END { }      

1;
