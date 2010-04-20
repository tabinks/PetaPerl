package Utilities::Trim;

sub Trim {
# trims whitespace off front and back of a string
# usage: $newString = &Tab::Text::Trim( $oldString ); 

    my ($string) = @_;
    $string =~ s/^\s*(.*?)\s*$/$1/;    
    return $string;
}

sub Underscore {
# trims whitespace off front and back of a string
# usage: $newString = &Tab::Text::Trim( $oldString ); 

    my ($string) = @_;
    $string =~ s/\s+/_/g;    
    return $string;
}
 
END { }      
1;
