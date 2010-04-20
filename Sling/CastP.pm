package Sling::CastP;

use Sling::Configure;
use Sling::Verbose;

################################################################
# pocketAtomCount
# 
# Created: January 16, 2006
################################################################
sub CastP {
    
    my ($PDB,$radius) = @_;

    Sling::Verbose::Verbose("Sling::CastP::CastP $pdbPath $radius");

    $pdbPath = $CFG{'LOCAL_CAST'}.'/'.substr($PDB,1,2)."/$PDB.pdb";

    if (!Sling::GpssFileTests::CastpFilesExist($PDB)) {
	
	# Set name
	my $name = $pdbPath;
	$name =~ s/\.pdb//;
	
	if ($ENV{'ARCH'} =~ /IRIX|ALPHA/) {
	    die("Sling::CastP::CastP is set to run on linux only.\n");
	}
	
	# Establish file permissions
	system("touch $name.info");
	system("$CMD{'FORCAST_LINUX'} $pdbPath > $name.nH.pdb");
	system("$CMD{'PDB2GALF_LINUX'} -r $radius $name.nH.pdb $name > $name.log");
	system("$CMD{'DELCX_LINUX'} $name > /dev/null");
	system("$CMD{'MKALF_LINUX'} $mkalf_cmd $name > /dev/null");
	system("mv $pdbPath $name.orig.pdb; mv $name.nH.pdb $pdbPath");
	#system("chmod 644 $name*");
	system("$CMD{'CASTp_LINUX'} $name > /dev/null");
	system("mv $name.orig.pdb $pdbPath");
	system("rm -f $name $name.log $name.dt $name.alf $name.info $name.temp");
    } else {
	Sling::Verbose::Verbose("Sling::CastP::CastP - all cast files exist");
      }

    if (!Sling::GpssFileTests::CastpFilesExist($PDB)) {
	die "Sling::CastP::Castp castp files were not created\n";
    }
}
END {}
1;
