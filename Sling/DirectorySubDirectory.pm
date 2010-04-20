package Sling::DirectorySubDirectory;

sub DirectorySubDirectory {
    
    my ($PDB,$DIR) = @_;

    $path = $DIR.'/'.substr($PDB,1,2);
    
    if (!-e $path) {
	`mkdir $path`;
	
    }
}


END {}
1;
