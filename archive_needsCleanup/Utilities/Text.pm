package Tab::Text;

require Exporter;
use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&GetC &Trim);

use vars       qw(@tmp $string);

sub GetC { 
    @tmp = ();
   
    $_ = $_[0];
    while (/\G([0-9a-zA-Z\+\-])/g) {
	push @tmp, $1;
    }
    return @tmp;
}

sub Trim {
# trims whitespace off front and back of a string
# usage: $newString = &Tab::Text::Trim( $oldString ); 

    my ($string) = @_;
    $string =~ s/^\s*(.*?)\s*$/$1/;    
    return $string;
}
 
END { }      

1;
