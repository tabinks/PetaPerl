package Protein;

# Usage:
#           # declare new protein object
#           my $protein = new Protein;
#              $protein->init($PDB);
#           # parse poc file
#              foreach (@{ $protein->{POC}{FILE} }) { }

use strict;
use lib "/home1/abinkowski/lib";
use Tab::File;

require Exporter;

use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 0.01;

@ISA         = qw( Exporter );
@EXPORT      = qw( &new &init );    # Symbols to autoexport (:DEFAULT tag)
@EXPORT_OK   = qw( &DESTROY );      # Symbols to export on request
%EXPORT_TAGS = ( );                 # eg: TAG => [ qw!name1 name2! ]


my $CAST_DIR = "/cast";
#################################################
# exported package globals
use vars      qw($Var1 %Hashit);
# initialize package globals
$Var1   = '';
%Hashit = ();

#################################################
# non-exported package globals
use vars      qw(@more $stuff $pdb_dir);
# which are still accessible as $Some::Module::stuff
$stuff  = '';
@more   = ();

#################################################
# file-private lexicals go here
my $priv_var    = '';
my %secret_hash = ();

# here's a file-private function as a closure,
# callable as &$priv_func.
my $priv_func = sub {
    # stuff goes here.
};

#####################################################################
# Exported Functions                                                #
##################################################################### 
sub new {
    my $classname  = shift;         
    my $self      = {};             # Allocate new memory
    bless($self, $classname);       # Mark it of the right type

    $self->_initialize();           # Just in case
    return $self;                   # And give it back
} 


sub init ($pdb) {
# set all file names, locations, and loads the files into array
    
    my $self = shift;
    my $pdb = shift;

    $pdb_dir = substr($pdb,1,2);

    $self->{PDB}{NAME} = $pdb.".pdb";
    $self->{PDB}{DIR} = "$CAST_DIR/$pdb_dir/$pdb\.pdb";
    $self->{PDB}{FILE} = [ &Tab::File::LoadFile(INPUT  => $self->{PDB}{DIR},
						CHOMP  => 1) ];
    
    $self->{POC}{NAME} = $pdb.".poc";
    $self->{POC}{DIR} = "$CAST_DIR/$pdb_dir/$pdb\.poc";
    $self->{POC}{FILE} = [ &Tab::File::LoadFile(INPUT  => $self->{POC}{DIR},
						CHOMP  => 1) ];
    
    $self->{POCINFO}{NAME} = $pdb.".pocInfo";
    $self->{POCINFO}{DIR} = "$CAST_DIR/$pdb_dir/$pdb\.pocInfo";
    $self->{POCINFO}{FILE} = [ &Tab::File::LoadFile(INPUT  => $self->{POCINFO}{DIR},
						    CHOMP  => 1) ];

    $self->{MOUTH}{NAME} = $pdb.".mouth";
    $self->{MOUTH}{DIR} = "$CAST_DIR/$pdb_dir/$pdb\.mouth";
    $self->{MOUTH}{FILE} = [ &Tab::File::LoadFile(INPUT  => $self->{MOUTH}{DIR},
						  CHOMP  => 1) ];
    
    $self->{MOUTHINFO}{NAME} = $pdb.".mouthInfo";
    $self->{MOUTHINFO}{DIR} = "$CAST_DIR/$pdb_dir/$pdb\.mouthInfo";
    $self->{MOUTHINFO}{FILE} = [ &Tab::File::LoadFile(INPUT  => $self->{MOUTHINFO}{DIR},
						      CHOMP  => 1) ];
}

#####################################################################
# OK_Exported / Non Exported  Functions                             #
##################################################################### 
sub _initialize {
# maybe useful later

}

sub DESTROY {
    my $self = shift;
    #printf("$self dying at %s\n", scalar localtime);
} 


# module clean-up code here (global destructor)
END { }       

1;
