package Sling;

# Usage:
#           # declare new protein object
#           my $protein = new Protein;
#              $protein->init($PDB);
#           # parse poc file
#              foreach (@{ $protein->{POC}{FILE} }) { }


use lib "/home1/abinkowski/lib";
use Tab::Text;
use Tab::AminoAcids;
use Tab::Parser;

sub create_scop_hash {

    open(FILE, "<$_[0]") || die "Couldn't open $_[0] for writing.";

    while(<FILE>) {
	@line = split /\s+/,$_;
	$line[2] =~ /([A-Z\-0-9])/;
	$tmp=$1;
	if($tmp eq "-"){$tmp=0;}
#	print $line[1].$tmp."  $line[3]\n";
	$key=$line[1].$tmp;
	$SCOP{$key}=$line[3];
    }
    close FILE;

    return %SCOP;
}

sub get_pocInfo {
# retrieve information found in .pocInfo files
    my %results;

    foreach (@_) {
	($z,$z,$id,$n_mth,$a_sa,$a_ms,$v_sa,$v_ms,$len,$cnr) = split(/\s+/,$_);
	$results{$id}{n_mth} = &Trim($n_mth);
	$results{$id}{a_sa}  = &Trim($a_sa);
	$results{$id}{a_ms}  = &Trim($a_ms);
	$results{$id}{v_sa}  = &Trim($v_sa);
	$results{$id}{v_ms}  = &Trim($v_ms);
	$results{$id}{len}   = &Trim($len);
	$results{$id}{cnr}   = &Trim($cnr);
    }
    return %results;
}

sub get_mouthInfo {
# retrieve information found in .mouthInfo files
    my %results;

    foreach (@_) {
        ($z,$z,$id,$n_mth,$a_sa,$a_ms,$l_sa,$l_ms,$ntri) = split(/\s+/,$_);
	    $results{$id}{n_mth} = &Trim($n_mth);
            $results{$id}{a_sa}  = &Trim($a_sa);
            $results{$id}{a_ms}  = &Trim($a_ms);
            $results{$id}{l_sa}  = &Trim($l_sa);
            $results{$id}{l_ms}  = &Trim($l_ms);
            $results{$id}{ntri}  = &Trim($ntri);
    }
    return %results;
}

sub get_pdb {
    my %tmp;
  
    foreach (@_) {
	next unless /^ATOM/;
	    my %results = &Tab::Parser::Pdb(
		    INPUT        => $_, RESIDUE_NAME => 1,
		    CHAIN_ID     => 1,  RESIDUE_NUM  => 1);
	    
	    if ($seen{$results{CHAIN_ID}}{$results{RESIDUE_NUM}} != 1) {
		$tmp{$results{CHAIN_ID}}{SEQ} .= $Amino{$results{RESIDUE_NAME}};
		$seen{$results{CHAIN_ID}}{$results{RESIDUE_NUM}} = 1;
	    }
    }
    return %tmp;
}

sub get_poc_seq {
# returns hash of poc information 
    my @tmp;

    foreach (@_) {
	next if $_ =~ /^\#/;
	    my %results = &Tab::Parser::Poc(
		    INPUT        => $_, RESIDUE_NAME => 1,
		    CHAIN_ID     => 1,  RESIDUE_NUM  => 1,
		    ATOM_NUMBER  => 1,  ATOM_NAME    => 1,
		    X_COORD      => 1,  Y_COORD      => 1,
		    Z_COORD      => 1,  POCKET_NUM   => 1);
	    
	    # check to make sure that residue is not entered more than once
	    # would normally happen because each atom is listed in .poc

	# Set main chain to 0 
	if($results{CHAIN_ID} eq "") {
	    $results{CHAIN_ID} = "0";
	}
#	print "Pocket Number:$results{POCKET_NUM} Chain Id:$results{CHAIN_ID} ";
#	print "Atom Num: $results{ATOM_NUMBER} Atom Name: $results{ATOM_NAME} Res Num:$results{RESIDUE_NUM}\n";

	@coords = ($results{RESIDUE_NAME},$results{RESIDUE_NUM},
		   $results{ATOM_NUMBER},$results{ATOM_NAME},$results{CHAIN_ID},
		   $results{X_COORD},$results{Y_COORD},$results{Z_COORD});

	push @{ $tmp[$results{POCKET_NUM}] }, [ @coords ] ;
    }

    return @tmp;
}

END { }       

1;
