package Cast::Ligand;
require Exporter;

use lib "/home/abinkowski/lib";
use Tab::Parser; 
use Tab::Array;
use Cast::Common;
use Cast::Pocket;
use Sling::PdbHeader;
use Carp;
#use strict;

$VERSION = 0.01;

my $cast_dir  = "/cast";
my $lpc_dir   = "/home/abinkowski/projects/pfizer/lpc";
my $tmp_dir   = "/tmp";

my $adiff_cmd    = "/home/abinkowski/projects/pfizer/scripts/diff.pl";
my $pdb2galf_cmd = "/home/abinkowski/bin/pdb2galf";
$PDBdb           = "/home/abinkowski/projects/shape/data/pdb_seqres_names.txt";

###########################################################################
sub new {
#
# Date: 6/23/02
# 
# Description: Creates a new ligand object and initialize
#              it.
#
###########################################################################
    my $class = shift;
    my $self  = {};         # allocate new hash for object
    bless($self, $class);
    $self->_init(@_);       # Call _init with remaining args
    return $self;
}

###########################################################################
sub _init {
#
# Initialize the ligand objects
#
###########################################################################
 
    my $self = shift;

    $self->{OUTPUT} = "array";     # Set defaults
    if (@_) {                      # inputed
        my %extra = @_;
        @$self{keys %extra} = values %extra;
    } 
    $self->Cast::Common::_fix_chain();   # Fix chain id
    $self->{PDB_DIR} = substr($self->{PDB},1,2); 
}

###########################################################################
sub describe {
#
# print out self (mostly for error checking)
###########################################################################
 
    my $self = shift;
    print "PDB:\t$self->{PDB}\tCHAIN:\t$self->{CHAIN_ID}\t";
    print "LIGAND:\t$self->{LIGAND}\tLIGAND NO.:\t$self->{LIGAND_NUM}\n";
}

###########################################################################
sub initialize {
#
# Initialize the ligand objects
# This can be called from the script to set the ligand name and number
###########################################################################
 
    my $self = shift;

    $self->{OUTPUT} = "array";     # Set defaults
    if (@_) {                      # inputed
        my %extra = @_;
        @$self{keys %extra} = values %extra;
    } 
    $self->Cast::Common::_fix_chain();   # Fix chain id
    $self->{PDB_DIR} = substr($self->{PDB},1,2); 
}

###########################################################################
sub bound_ligands {
# Date: 7/01/00
#
# Desription: Finds all the ligands bound to a specific pdb
#             and chain (?).  If no chain then returns all 
#             else it only returns that chain
#
# Updates:
#
###########################################################################

    my $self = shift;
    
    my @return = ();  # returned array of array
    my @pdbfield  = ();  

    my $pdb_file      = "$cast_dir/$self->{PDB_DIR}/$self->{PDB}.pdb";

    # Create clean pdb(no HET)
    #
    open (PDB,"< $pdb_file") 
	or Cast::Common::error("Couldn't open $pdb_file:$!");
    while (<PDB>) {
	next unless $_=~/^HET\s+/;
	$pdbfield[0]  = substr($_,0,5);   # Record Name
        $pdbfield[1]  = substr($_,7,3);   # Het Identifier
        $pdbfield[2]  = substr($_,12,1);  # ChainID
        $pdbfield[3]  = substr($_,13,4);  # Sequence number
        $pdbfield[4]  = substr($_,17,1);  # 
        $pdbfield[5]  = substr($_,20,5);  # 
        $pdbfield[6]  = substr($_,30,39); # Text

	foreach (@pdbfield) {$_ =~ s/\s+//g;} # trim all fields

	if (defined($self->{CHAIN_PDB})) {
	    if ($pdbfield[2] eq $self->{CHAIN_PDB}) {
		push @return, [@pdbfield];
	    }
	} else {
	    push @return, [@pdbfield];
	}

    }
    close PDB;
    return @return;
}

###########################################################################
sub ligand_protein_contacts {
# Date: 6/25/00
#
# Desription: Calculates the ligand protein contacts
#             and returns them in an array
#
# To Do:
#      - MAKE A RADIUS parameter that gets passed
# 
# Updates:
#
###########################################################################

    my $self = shift;

    my @tmp = ();     # for array of array
    my @return = ();  # returned array of array
    my @pdbfield  = ();  # for .diff file

    my $pdb_orig_file = "$cast_dir/$self->{PDB_DIR}/$self->{PDB}.pdb";

    my $pdb_file      = "$tmp_dir/$self->{PDB}.pdb";
    my $p_name        = "$tmp_dir/$self->{PDB}";
    my $p_out         = "$tmp_dir/$self->{PDB}.output";

    my $pdb_lig_file  = "$tmp_dir/$self->{PDB}.lig.pdb";
    my $p_lig_name    = "$tmp_dir/$self->{PDB}.lig";
    my $p_lig_out     = "$tmp_dir/$self->{PDB}.lig.output";
    my $output        = "$tmp_dir/$self->{PDB}.diff";
 

    # Create clean pdb(no HET)
    #
    open (PDB,"< $pdb_orig_file") 
	or Cast::Common::error("Couldn't open $pdb_orig_file:$!");
    open (OUT,"> $pdb_file") 
	or Cast::Common::error("Couldn't open $pdb_file:$!");
    while (<PDB>) {
	if ($_ =~ /^ATOM/) {
	    print OUT $_;
	}
    }
    close OUT;
    close PDB;

    # Create pdb with specified ligand
    #
    open (PDB,"< $pdb_orig_file")
	or Cast::Common::error("Couldn't open $pdb_orig_file:$!");
    open (OUT,"> $pdb_lig_file")
	or Cast::Common::error("Couldn't open $pdb_lig_file:$!");
    while (<PDB>) {
	my %results = &Tab::Parser::Pdb(
					INPUT        => $_, RECORD_NAME  => 1,
					CHAIN_ID     => 1,  RESIDUE_NUM  => 1,  
					RESIDUE_NAME => 1
					);
	
	if ($results{RECORD_NAME} eq "ATOM") {
	    print OUT $_;
	} elsif ( $results{RECORD_NAME} eq "HETATM" &&
		  $results{RESIDUE_NAME} eq $self->{LIGAND} &&
		  # $results{CHIAN_ID}   eq $self->{CHAIN_PDB} &&
		  $results{RESIDUE_NUM}  eq $self->{LIGAND_NUM}) {
	    print OUT $_;
	}
    } 
    close PDB;
    close OUT;

    # Do calculations
    #
    `$pdb2galf_cmd $pdb_file $p_name`;
    `$pdb2galf_cmd $pdb_lig_file $p_lig_name`;

    `delcx $p_name > /dev/null`; 
    `mkalf $p_name > /dev/null`; 
    `volbl -s 1 -c 0 -p $pdb_file $p_name > $p_out`;

    `delcx $p_lig_name > /dev/null`; 
    `mkalf $p_lig_name > /dev/null`; 
    `volbl -s 1 -c 0 -p $pdb_lig_file $p_lig_name > $p_lig_out`;

    # Uses a script
    #
    `perl $adiff_cmd $p_name.1.contrib $p_lig_name.1.contrib > $output`; 

    open (OUTPUT,"< $output")
	or Cast::Common::error("Couldn't open $ouput:$!");
    while (<OUTPUT>) {
	next unless $_=~/^ATOM/;    # ignore comment lines
	$pdbfield[0]  = substr($_,0,6);   # Record Name
        $pdbfield[1]  = substr($_,6,5);   # Atom number
        $pdbfield[2]  = substr($_,11,1);  #
        $pdbfield[3]  = substr($_,12,4);  # Atom name
        $pdbfield[4]  = substr($_,16,1);  # alt location indicator
        $pdbfield[5]  = substr($_,17,3);  # Residue Name
        $pdbfield[6]  = substr($_,20,1);  #
        $pdbfield[7]  = substr($_,21,1);  # Chain ID
        $pdbfield[8]  = substr($_,22,4);  # Residue Number 
        $pdbfield[9]  = substr($_,26,1);  # Insertion Code

	# This isn't perfect (could be buggs
        $pdbfield[10] = substr($_,27,8);  # Sa1
        $pdbfield[11] = substr($_,34,8);  # Sa2
        $pdbfield[12] = substr($_,42,10);  # SaDiff
        $pdbfield[13] = substr($_,52,10);  # Ms1
        $pdbfield[14] = substr($_,62,8);  # Ms2
        $pdbfield[15] = substr($_,70,10);  # MsDiff
	
	foreach (@pdbfield) {
	    $_ =~ s/\s+//g;
	}
	push @return, [ @pdbfield ];
    }
    close OUTPUT;

    # Put sequence in object
    # might forget its there
    # $self->ligand_contact_sequence(@return);

    # Return array
    return @return;
}

###########################################################################
sub ligand_contact_coordinates(@) {
#
# Date: 6/25/00
#
# Desription: Calculates the ligand protein contacts
#             and returns them in an array
#
# To Do:
#      - Is using Calpha's correct???
# 
# Updates:
#
###########################################################################

    my $self = shift;
    my @contactList = @_;

    # Declarations
    my @return    = (); # returned array
    my @xyz       = (); # tmp holder
    my @seen      = (); # some atom contacts are listed 2x
    my $tmp;
    my $chain;

    foreach (@contactList) {

	$tmp   = @$_[8];
	$chain = @$_[7];

	if (!$seen[$tmp]) {
	    @xyz =  $self->Cast::Common::residue_coordinates($tmp,$chain);
	    push @return, [@xyz];
	    $seen[$tmp]=1;
	}
    }
    
    # Return to program
    return @return
}

###########################################################################
sub ligand_contact_sequence(@) {
#
# Date: 6/25/00
#
# Desription: Returns a scalar of the sequence and 
#             also sets it in $ligand->{SEQUENCE}
#
# To Do:      Take args to return as string or array (w/res num)
#             
###########################################################################

    my $self = shift;
    my @contactList = @_;

    # Declarations
    my @return    = (); # returned array
    my %seen      = (); # some atom contacts are listed 2x
    my $tmp;

    $self->{SEQUENCE} = ""; # clear out old sequence 

    foreach (@contactList) {
	$tmp = "@$_[8]";
	if (!$seen{$tmp}) {        
	    $self->{SEQUENCE} .= $AminoAcids{@$_[5]};
	    $seen{$tmp}=1;
	}
    }
    return $self->{SEQUENCE}; # make available to string
}
###########################################################################
sub ligand_pocket_search(@) {
#
# Date: 7/10/02
#
# Desription: Search a ligand contact sequence against the pocDB
#             
#             
###########################################################################

    my $self = shift;
    if (@_) {                      # inputed
        my %extra = @_;
        @$self{keys %extra} = values %extra;
    } 

    # Declarations
    my @coordinateList    = (); # ligand object coordinates

    my $tmp_dir         = "/tmp";
    my $home            = "/home/abinkowski/projects";
    my $ligand_database = "$home/pfizer/data/ligand.db";
    my $pocket_database = "$home/shape/data/database/3.25.02.5.100.db";
    my $label = "$self->{PDB}.$self->{LIGAND}.$self->{LIGAND_NUM}";

#    if ($self->{DB} eq 'ligand') {
	#$pocket_database = $ligand_database;
   # }
    # Get sequence from database
    #
    `grep "> $self->{PDB} | $self->{LIGAND} | $self->{LIGAND_NUM}" -A 1 $ligand_database > $tmp_dir/$label.seq`;

    # Initial Search
    #
    `$home/shape/scripts/ssearch33  -H -B -b 100000 -E 10000 $tmp_dir/$label.seq $pocket_database | grep "#" | tr ')' ' ' | awk '{if(\$11>=20){print \$0}}' > $tmp_dir/$label.fasta.list`;

    # Build tmp database
    #
    `awk '{print "grep "q">"\$3" | "\$5" | "\$7,q,db" -A 1"}' q='\"' db=$pocket_database $tmp_dir/$label.fasta.list | sh > $tmp_dir/$label.tmp.db`;
    
    # Search against temp database
    #
    `$home/shape/scripts/ssearch33 -B -z 11  -E 2 $tmp_dir/$label.seq $tmp_dir/$label.tmp.db > $tmp_dir/$label.pocket.search`;

    # Clean output
    $KS_STAT=`grep 'Kolmogorov-Smirnov' $tmp_dir/$label.pocket.search`;
    @KS=split /\s+/,$KS_STAT; # Don't know why need this

    `grep "#" $tmp_dir/$label.pocket.search | awk '{print \$3,\$5,\$7,\$14,ks}' ks=$KS[3]> $tmp_dir/$label.pocket.list`;

    #
    # Output and advanced annotation
    #
    if ($self->{RMSD} eq 'yes') {
	# Only do this if you need coordinates (save running time)
	@contactList      = $self->ligand_protein_contacts();
	@coordinateList   = $self->ligand_contact_coordinates(@contactList);
    } 	
    
    open (LIST,"< $tmp_dir/$label.pocket.list")
	or Cast::Common::error("Couldn't open $tmp_dir/$label.pocket.list: $!\n");
    while (<LIST>) {
	my ( $pdb, $pocket, $chain, $e_value, $ks ) =  split /\s+/, $_;
	if ($ks < 0.1) {  # Model validated

            # RMSd calculation
	    if ($self->{RMSD} eq 'yes') {
		my $hitPocket = Cast::Pocket->new( PDB       => $pdb, 
						   POCKET_ID => $pocket,
						   CHAIN_ID  => $chain );
		my @pocketList = $hitPocket->pocket_coordinates( ATOMS=>'c_alpha' );
		$rmsd = $hitPocket->Cast::Common::rmsd(\@pocketList,\@coordinateList);
		$hitPocket->DESTROY();
	    } else {
		my $rmsd = "";
	    }
	    @tmp = ($self->{PDB},$self->{LIGAND},$self->{LIGAND_NUM},
		    $pdb, $pocket, $chain, $e_value, $ks, 
		    &PdbHeader::return_name( $pdb, $chain, $PDBdb ), $rmsd);
	    push @return, [@tmp];
	}
    }
    close LIST;
    return @return;
}

###########################################################################
sub ligand_contact_pockets(@) {
#
# Date: 6/25/00
#
# Desription: Calculates the ligand protein contacts
#             pockets and returns them in a hash
#
# Usage:   
#          my @pockets     = $ligand->ligand_contact_pockets(@contactList);
#
# Updates:
#          7/01/02  Put surface & atoms; return as array of hashes
# 
###########################################################################

    my $self = shift;
    my @contactList = @_;

    # Declarations
    my @return   = {};
    my @pockets   = (); 
    my ($chain, $atom, $res_number, $sa, $ms);
    
    foreach (@contactList) {
	@pockets      = (); 
	$res_number   = @$_[8]; 
	$chain        = @$_[7];
	$atom         = @$_[3];
	$sa           = @$_[12];
	$ms           = @$_[15];

	@pockets=$self->Cast::Common::residue_pockets($res_number,
						      $chain, $atom);
	foreach my $poc (@pockets) {
	    $return[$poc]{NUMBER}   = $poc; # Pocket Number
	    $return[$poc]{SURFACE} += $sa;  # Sa diff
	    $return[$poc]{ATOMS}++;         # Count number of atoms   
	} 
    }


#    return Tab::Array::array_unique( @return );
    return @return;
}


###########################################################################
sub DESTROY {
#
###########################################################################

    my $self = shift;
#    printf("$self dying at %s\n", scalar localtime);
} 
###########################################################################

END {}
1;























