package Cast::Common;
require Exporter;

use lib "/home/abinkowski/lib";
use Tab::Parser; 
use Tab::Array;
use Carp;
#use strict;

$VERSION = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(%AminoAcids);

use vars       qw(%AminoAcids);

%AminoAcids   = ( "GLY", "G", "ALA", "A", "VAL", "V", "LEU", "L",
		  "ILE", "I", "SER", "S", "THR", "T", "CYS", "C",
		  "MET", "M", "PRO", "P", "ASP", "D", "ASN", "N",
		  "GLU", "E", "GLN", "Q", "LYS", "K", "ARG", "R",
		  "HIS", "H", "PHE", "F", "TYR", "Y", "TRP", "W"
		  );
%AminoHydrophobicity = (
			"ALA"=>"0","ARG"=>"0","ASN"=>"0","ASP"=>"0",       
			"CYS"=>"1","GLN"=>"0","GLU"=>"0","GLY"=>"0",
			"HIS"=>"0","ILE"=>"1","LEU"=>"1","LYS"=>"0",         
			"MET"=>"1","PHE"=>"1","PRO"=>"0","SER"=>"0",         
			"THR"=>"0","TRP"=>"1","TYR"=>"0","VAL"=>"1");

my $cast_dir  = "/cast";
my $tmp_dir   = "/tmp";
my $rmsd_cmd  = "/home/abinkowski/projects/simple_rms/rms";
 
###################################################
sub _fix_chain {
# Fix chain id (0 main chain)
###################################################

    my $self = shift;

    if (defined($self->{CHAIN_ID})) {
	if ($self->{CHAIN_ID} eq "0") {
	    $self->{CHAIN_PDB} = "";
	} else {
	    $self->{CHAIN_PDB} = $self->{CHAIN_ID};
	}
    }
}
###################################################
sub error {
#
###################################################
    my $text = $_[0];
    croak($text);
#    print STDERR whoami()." $text\n";

}

###################################################
sub whoami  { (caller(1))[3] }
###################################################

###################################################
sub rmsd {
# calculates the rmsd between 2 pockets
# 
# Change Log:
#           10/25/02  Removed oop approach to rmsd
#                     no need to be "aware"
#
###################################################
#    my $self = shift;

    my ($x,$y) = @_;
    my $result;

#    my $file_x = "$tmp_dir/$self->{PDB}.rmsd.1";
#    my $file_y = "$tmp_dir/$self->{PDB}.rmsd.2";
    
    my $file_x = "$tmp_dir/rmsd.1";
    my $file_y = "$tmp_dir/rmsd.2";

    open (X,"> $file_x")
        or error("Couldn't open $file_x");
    open (Y,"> $file_y")
        or error("Couldn't open $file_y");

    for (my $i=0; $i<@$x; $i++) {
        print X "$x->[$i][0] $x->[$i][1] $x->[$i][2]\n";
    }
    for (my $i=0; $i<@$y; $i++) {
        print Y "$y->[$i][0] $y->[$i][1] $y->[$i][2]\n";
    }
    close X;
    close Y;

    $rmsd = `$rmsd_cmd $file_x $file_y`;

    # clean up
    `rm $file_x $file_y`;
    return $rmsd;
}

###########################################################################
sub residue_coordinates {
#
# Date: 6/25/00
#
# Desription: Returns an array of xyz coordinates
#             for a given residue number
#
# Dependencies: Relies on object having {PDB},
#               {PDB_DIR},{CHAIN_PDB} defined
#
# To Do:      Error check dependencies
#
###########################################################################

    my $self = shift;

    my %results = ();              # for Parser.pm
    my @xyz = ();

    my ($residue_num,$chain) = @_;
#    $chain =~ s/\s+//g; # Parser trims spaces so need to trim
                        # $chain which would return " "

    open(PDB,"< $cast_dir/$self->{PDB_DIR}/$self->{PDB}.pdb")
        or error("Couldn't open $file : $!\n");

    while (<PDB>) {
        next unless $_=~ /^ATOM/;
        my %results = &Tab::Parser::Pdb(
                                        INPUT        => $_, CHAIN_ID     => 1,
                                        RESIDUE_NUM  => 1,  ATOM_NAME    => 1,
                                        X_COORD      => 1,  Y_COORD      => 1,
                                        Z_COORD      => 1,  ATOM_NUMBER  => 1
                                        );

        if ($results{RESIDUE_NUM} eq $residue_num &&
            $results{CHAIN_ID} eq $chain &&
            $results{ATOM_NAME} eq "CA") {
            $xyz[0] = $results{X_COORD};
            $xyz[1] = $results{Y_COORD};
            $xyz[2] = $results{Z_COORD};
        }
    }
    close PDB;
    return @xyz;
}
###########################################################################

###########################################################################
sub residue_pockets {
#
# Date: 6/25/00
#
# Desription: Returns an array of pockets from 
#             a given residue from a chain
#             
# Dependencies: Relies on object having {PDB},
#               {PDB_DIR},{CHAIN_PDB} defined
#
# To Do:      Error check dependencies
#
###########################################################################

    my $self = shift;

    my %results = ();              # for Parser.pm
    my @pockets = ();

    my ($residue_num,$chain,$atom) = @_;

    # IF ATOM NE THEN PICK CA???
    open(POC,"< $cast_dir/$self->{PDB_DIR}/$self->{PDB}.poc")
        or error("Couldn't open $file : $!\n");

    while (<POC>) {
        next unless $_=~ /^ATOM/;
        my %results = &Tab::Parser::Pdb(
                                        INPUT        => $_, CHAIN_ID     => 1,
                                        RESIDUE_NUM  => 1,  ATOM_NAME    => 1,
                                        ATOM_NUMBER  => 1,  POCKET_NUM   => 1 );

        if ($results{RESIDUE_NUM} eq $residue_num &&
            $results{CHAIN_ID} eq $chain &&
            $results{ATOM_NAME} eq $atom) {
	    push @pockets, $results{POCKET_NUM};
        }
    }
    close PDB;
    return @pockets;
}


###################################################
sub _atomRecord ($record) {
#
# Private function that renames the pdb array with easy read
# naming conventions 
###################################################
    my %pdbfield={};

    $pdbfield{record_name}    = substr($record,0,6); 
#    $pdbfield{atom_number}    = Cast::Common::trim(substr($record,6,5));  
#    $pdbfield{2}              = substr($record,11,1);  #
#    $pdbfield{atom_name}      = Cast::Common::trim(substr($record,12,4)); 
#    $pdbfield{4}              = substr($record,16,1);  # Location indicator
#    $pdbfield{residue_name}   = Cast::Common::trim(substr($record,17,3));
#    $pdbfield{residue_letter} = $AminoAcid[$pdbfield{residue_name}];
#    $pdbfield{6}              = substr($record,20,1);  #
#    $pdbfield{chain_id}       = substr($record,21,1); 
#    $pdbfield{residue_number} = Cast::Common::trim(substr($record,22,4)); 
#    $pdbfield{9}              = substr($record,26,1);  # Insertion Code
#    $pdbfield{pocket_id}      = Cast::Common::trim(substr($record,67,3)); 
#    $pdbfield{x}              = substr($record,31,7);
#    $pdbfield{y}              = substr($record,39,7);
#    $pdbfield{z}              = substr($record,47,7);
#    $pdbfield{record}         = $record;        
#    $pdbfield{hydrophobicity} = $AminoHydrophobicity[$pdbfield{residue_name}];
    
    if ($pdbfield{chain_id} == " ") {    
	$pdbfield{chain_id} = "0";
    }
    return %pdbfield;
}

sub trim {
# trims whitespace off front and back of a string
# usage: $newString = &Tab::Text::Trim( $oldString ); 

    my ($string) = @_;
    $string =~ s/^\s*(.*?)\s*$/$1/;    
    return $string;
}

END {}
1;























