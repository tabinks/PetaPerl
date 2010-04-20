package Tab::File;

# $string = &Tab::File::LoadFile( INPUT => $o_file,
#				      CHOMP => 1,
#				      TYPE  => "string");
#
# @OVERLAP_FILE = &Tab::File::LoadFile( INPUT => $o_file,
#				      CHOMP => 0);

require Exporter;
use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&LoadFile);

use vars       qw(@tmp);

sub LoadFile {
    my @data;
    my %args = (
		INPUT        => 0,
		CHOMP        => 0,
		SHIFT        => 0,       # shifts untils not a first blank line
		TYPE         => "array", # returna as array or string
		@_,
		);

    open(FILE, $args{INPUT}) || die "Tab::File::LoadFile->Error:\n\tCouldn't open $args{INPUT}D! : $!\n";
    while(<FILE>) {
	if ($args{CHOMP} == 1) {
	    chomp;
	}

	if ($args{TYPE} eq "array") {
	    push @data, $_;
	} elsif ($args{TYPE} eq "string") {
	    $string .= $_;
	}
    }
    close FILE;

    # check for empty first lines
    if ($args{SHIFT} == 1) {
	while ($data[0] eq "") {
	    shift @data;	    
	}
    }

    #return
    if ($args{TYPE} eq "string") {
	return $string;
    }  elsif ($args{TYPE} eq "array") {
	return @data;
    }
}


END { }      

1;





