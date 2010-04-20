package Sling::DirectoryRecursive;

use Sling::Configure;
use Sling::PdbParse;
use Sling::GpssFileTests;

sub DirectoryRecursive {
    
    my ($MODE) = @_;
    my @return;

    if ($MODE eq 'CAST') {
	$LOCAL_DIRECTORY = "LOCAL_CAST";
    } elsif ($MODE eq 'CASTCHAIN') {
	$LOCAL_DIRECTORY = "LOCAL_CAST";
    } elsif ($MODE eq 'CASTALL') {
	$LOCAL_DIRECTORY = "LOCAL_CAST";
    } elsif ($MODE eq 'HPC') {
	$LOCAL_DIRECTORY = "LOCAL_HPC";
    } elsif ($MODE eq 'DPC') {
	$LOCAL_DIRECTORY = "LOCAL_DPC";
    } elsif ($MODE eq 'CSA') {
	$LOCAL_DIRECTORY = "LOCAL_CSA";
    } else {
	print "Need to define MODE\n";
	exit(1);
    }

    opendir(DIR, $CFG{$LOCAL_DIRECTORY}) or 
	die "can't opendir $CFG{'LOCAL_DIRECTORY'}: $!";
    
    while (defined($pdbdir = readdir(DIR))) {
	next if $pdbdir =~ /^\.\.?$/;           # Ignore .files
	next if $pdbdir !~ /^[a-z0-9]{2}$/;     # Ignore non-pdb directories

	#print "$pdbdir\n";
	opendir(PDBDIR, "$CFG{$LOCAL_DIRECTORY}/$pdbdir") 
	    or die "can't opendir $pdbdir: $!";
	
	#################################################################
	#
	#################################################################
	while (defined($pdbfile = readdir(PDBDIR))) {
	    #print $CFG{$LOCAL_DIRECTORY}."/$pdbdir/$pdbfile\n";
	    # Could add switches to make this all files mode

	    #############################################################
	    # Match both cast and castchain
	    #############################################################
	    if ($MODE eq 'CAST') {
		next unless $pdbfile =~ /^([a-z0-9]{4})\.pdb$/;
		if (Sling::GpssFileTests::castFilesExist($1)) {
		    push @return, $1;
		}

	    #############################################################
	    # Match both cast and castchain
	    #############################################################
	    } elsif ($MODE eq 'CASTCHAIN') {
		next unless $pdbfile =~ /^([a-z0-9]{4}\.[0-9A-Z])\.pdb$/;
		if (Sling::GpssFileTests::castFilesExist($1)) {
		    push @return, $1;
		}
		
	    #############################################################
	    # Match both cast and castchain
	    #############################################################
	    } elsif ($MODE eq 'CASTALL') {
		if ($pdbfile =~ /^([a-z0-9]{4})\.pdb$/) {
		    if (Sling::GpssFileTests::castFilesExist($1)) {
			push @return, $1;
		    }
		}
		if ($pdbfile =~ /^([a-z0-9]{4}\.[0-9A-Z])\.pdb$/) {
		    if (Sling::GpssFileTests::castFilesExist($1)) {
			push @return, $1;
		    }
		}

	    #############################################################
	    # HPC
	    #############################################################		
	    } elsif ($MODE eq 'HPC') {
		next unless $pdbfile =~ /^([a-z0-9]{4}\.\w+\.\d+\.\w+\.lpc)\.poc$/;
		push @return, $1;
		
	    #############################################################
	    # DPC
	    #############################################################		
	    } elsif ($MODE eq 'DPC') {
		next unless $pdbfile =~ /^([a-z0-9]{4}\.dna)\.poc$/;
		push @return, $1;
		
	    #############################################################
	    # DPC
	    #############################################################		
	    } elsif ($MODE eq 'CSA') {
		#next unless $pdbfile =~ /^(\w{4}\.\w\.\w+\.csa)\.poc$/;
		next unless $pdbfile =~ /^(\w{4}\.\w+\.csa)\.poc$/;
		push @return, $1;
	    }
	}
	closedir(PDBDIR);
	#if ($pdbdir eq "04") {return @return;}
    }
    closedir(DIR);
    return @return;
}


END {}
1;
