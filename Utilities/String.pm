package Utilities::String;

sub StringTrim {
# trims whitespace off front and back of a string
# usage: $newString = &Tab::Text::Trim( $oldString ); 

    my ($string) = @_;
    $string =~ s/^\s*(.*?)\s*$/$1/;    
    return $string;
}

sub StringUnderscore {
# trims whitespace off front and back of a string
# usage: $newString = &Tab::Text::Trim( $oldString ); 

    my ($string) = @_;
    $string =~ s/\s+/_/g;    
    return $string;
}
 
END { }      
1;
