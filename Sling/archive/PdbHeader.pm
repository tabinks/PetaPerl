package PdbHeader;

$VERSION     = 0.01;

sub return_name {
    
    my ($pdb,$chain, $file) = @_;

    if ($chain eq "0") {
	$tmpchain=""; 
    } else {
	$tmpchain=$chain;
    }
    
    $name =`grep '$pdb\_$tmpchain' $file | awk '{print \$4,\$5,\$6,\$7,\$8,\$9,\$10,\$11,\$12,\$13,\$14,\$15,\$16,\$17,\$18,\$19,\$20}'`;
    $name =~ s/\s*$//;
    $name =~ s\ \_\g;

    return $name;
}

END { }       

1;
     
