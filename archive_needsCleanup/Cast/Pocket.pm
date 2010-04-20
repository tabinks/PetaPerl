package Cast::Pocket;
require Exporter;

use lib "/home/abinkowski/lib";
use Tab::Parser; 
use Cast::Common;

$VERSION = 0.01;

 
my $cast_dir  = "/cast";
my $tmp_dir   = ".";
my $rmsd_cmd  = "/home/abinkowski/projects/simple_rms/rms";


###################################################
sub new {
    my $class = shift;
    my $self  = {};         # allocate new hash for object
    bless($self, $class);
    
    $self->_init(@_);       # Call _init with remaining args

    $self->{TMP_DIR} = ".";
    $self->{RMSD_CMD} = "/home/abinkowski/projects/simple_rms/rms";
    $self->{CAST_DIR} = "/cast";   

    return $self;
}


###########################################################################
sub _init {
#
# This is called on new, might not have passes any args like pdb or
# chain.  I am calling initialize as a function explicitly.
###########################################################################

    my $self = shift;

    # Set defaults
    $self->{OUTPUT} = "array";
    # inputed
    if (@_) {
        my %extra = @_;
        @$self{keys %extra} = values %extra;
    } 
    #$self->Cast::Common::_fix_chain();   # Fix chain id
    #$self->{PDB_DIR} = substr($self->{PDB},1,2); 
} 

###########################################################################
sub initialize {
#
# This is called on new, might not have passes any args like pdb or
# chain.  I am calling initialize as a function explicitly.
###########################################################################

    my $self = shift;

    # inputed
    if (@_) {
        my %extra = @_;
        @$self{keys %extra} = values %extra;
    } 
    $self->Cast::Common::_fix_chain();   # Fix chain id
    $self->{PDB_DIR}   = substr($self->{PDB},1,2); 
    $self->{PDB_ARRAY} = $self->_pdb_array();
} 

###########################################################################
sub _pdb_array {
#  Takes a pocket object set by initialize and 
#  returns an array of an array of the coordinates
#  of the pocket.
#  
###########################################################################    

    my $self = shift;

    # Declarations
    my @return             = (); # returned array
    my @tmp                = (); # tmp holder

    # Set variables
    my $file      = "$cast_dir/$self->{PDB_DIR}/$self->{PDB}.poc";

    # Check and open poc file
    if (-e "$file") {
	open (POC, "< $file") 
	    or &Cast::Common::error("Cast::Pocket::pocket_coordinates:\tCouldn't open $file: $!");
    } else {
	&Cast::Common::error("Cast::Pocket::pocket_coordinates:\tCouldn't open $file: $!");
    }
    
    # Search 
    while (<POC>) {
	next if $_ =~ /^\#/;
	next if $_ =~ /^\s+$/;
	next if $_ =~ //;
	push (@return, [ &Cast::Common::_atomRecord($_) ]);
    }	
    close POC;     

    # Return to program
    return @return
}

###########################################################################
sub pocket_atoms {
#  Takes a pocket object set by initialize and 
#  returns an array of an array of the coordinates
#  of the pocket.
#  
###########################################################################    

    my $self = shift;

    # Declarations
    my %results   = (); # for parse.pm
    my @return    = (); # returned array
    my @tmp       = (); # tmp holder

    # Set variables
    my $file      = "$cast_dir/$self->{PDB_DIR}/$self->{PDB}.poc";

    # Check and open poc file
    if (-e "$file") {
	open (POC, "< $file") 
	    or &Cast::Common::error("Cast::Pocket::pocket_coordinates:\tCouldn't open $file: $!");
    } else {
	&Cast::Common::error("Cast::Pocket::pocket_coordinates:\tCouldn't open $file: $!");
    }
    
    # Search 
    while (<POC>) {
	next if $_ =~ /^\#/;
	next if $_ =~ /^\s+$/;
	my %results = &Tab::Parser::Poc(
					INPUT        => $_, CHAIN_ID     => 1,  
					RESIDUE_NUM  => 1,  RESIDUE_NAME => 1,
					POCKET_NUM   => 1,  ATOM_NAME    => 1,
					ATOM_NUMBER  => 1 
					);

	# search order atom number
	if ($results{POCKET_NUM} eq $self->{POCKET_ID} &&
	    $results{CHAIN_ID} eq $self->{CHAIN_PDB}) {
	    $tmp[0] = $results{RESIDUE_NUM};
	    $tmp[1] = $results{RESIDUE_NAME};
	    $tmp[2] = $results{ATOM_NAME};
	    $tmp[3] = $results{ATOM_NUMBER};
	    push @return, [ @tmp ];
	}
    }	
    close POC;     

    # Return to program
    return @return
}

###########################################################################
sub pocket_residues {
#  Takes a pocket object set by initialize and 
#  returns an array of an array of the unique
#  residues of the pocket.  Calls pocket_atoms first.
#  
#  Usage: 
#          my @pocketResidues = $pocket->pocket_residues();
#          print_array_of_array(@pocketResidues);
#
#  10/3/02 - TAB
###########################################################################    

    my $self = shift;

    # Declarations
    my @return    = (); # returned array
    my %seen      = ();

    my @pocketList = $self->pocket_atoms();

    foreach ( @pocketList ) {
	if ($seen{"@$_[0]@$_[1]"} != 1) {
	    push @return , [ @$_[0], @$_[1] ];
	    $seen{"@$_[0]@$_[1]"} = 1;
	}
    }
    
    return @return;
}

###########################################################################
sub pocket_sequence {
#  Takes a pocket object set by initialize and 
#  returns a hash of sequnces and sequence concatenated with residue num
#  
#       my $pocketSequence = $pocket->pocket_sequence();
#       print $pocketSequence{SEQUENCE};
#       print $pocketSequence{SEQUENCE_NUM};
#       print $pocketSequence{SEQUENCE_LENGTH};
#
# 10/03/02 TAB 
###########################################################################    

    my $self = shift;

    # Declarations
    my %return          = (); # returned array
    my @pocket_residues = $self->pocket_residues();

    foreach ( @pocket_residues ) {
        $return{SEQUENCE}      .= $AminoAcids{@$_[1]};
        $return{SEQUENCE_NUM}  .= $AminoAcids{@$_[1]}.@$_[0];
    }
    $return{SEQUENCE_LENGTH} = length($return{SEQUENCE});
    return %return;
}

###########################################################################
sub describe {
#
# print out self (mostly for error checking)
###########################################################################
 
    my $self = shift;
    print "PDB:\t$self->{PDB}\tCHAIN:\t$self->{CHAIN_ID}\t";
    print "POCKET:\t$self->{POCKET_ID}\n";
}

###################################################
sub pocket_coordinates {
#  Takes a pocket object set by initialize and 
#  returns an array of an array of the coordinates
#  of the pocket.
#  
#  Usage:
#    $pocket = Cast::Pocket->new();   # New pocket object
#    $pocket->initialize( PDB=>"1bcs",
#                     POCKET_ID=>55,
#                     CHAIN_ID=>"A");
#    @pocketList = $pocket->pocket_coordinates( ATOMS=>"all" );
###################################################
    
    my $self = shift;

    # Declarations
    my %results   = (); # for parse.pm
    my @return    = (); # returned array
    my @xyz       = (); # tmp holder

    # Set defaults
    my %args = (
                ATOMS       => "c_alpha",
                @_,
                );

    # Set variables
    my $file      = "$cast_dir/$self->{PDB_DIR}/$self->{PDB}.poc";

    # Check and open poc file
    if (-e "$file") {
	open (POC, "< $file") 
	    or Cast::Common::error("Cast::Pocket::pocket_coordinates:\tCouldn't open $file: $!\n");
    } else {
	Cast::Common::error("Cast::Pocket::pocket_coordinates:\t $file does not exist: $!\n");
    }
    
    # Search 
    while (<POC>) {
	next if $_ =~ /^\#/;
	next if $_ =~ /^\s+$/;
	my %results = &Tab::Parser::Poc(
					INPUT        => $_, CHAIN_ID     => 1,  
					RESIDUE_NUM  => 1,  RESIDUE_NAME => 1,
					POCKET_NUM   => 1,  ATOM_NAME    => 1,
					X_COORD      => 1,  Y_COORD      => 1,
					Z_COORD      => 1,  ATOM_NUMBER  => 1 
					);

	# search order atom number
	if ($results{POCKET_NUM} eq $self->{POCKET_ID} &&
	    $results{CHAIN_ID} eq $self->{CHAIN_PDB}) {
	    $xyz[0] = $results{X_COORD};
	    $xyz[1] = $results{Y_COORD};
	    $xyz[2] = $results{Z_COORD};

	    # Check argument for cA atoms
	    if ($args{ATOMS} eq "c_alpha" && $results{ATOM_NAME} eq "CA") {
		push @return, [ @xyz ];
	    } elsif ($args{ATOMS} eq "all") {                             
		push @return, [ @xyz ];
	    }
	}
    }	
    close POC;     

    # Return to program
    return @return
}

###################################################
sub DESTROY {
    my $self = shift;
#    printf("$self dying at %s\n", scalar localtime);
} 

END {}
1;



















