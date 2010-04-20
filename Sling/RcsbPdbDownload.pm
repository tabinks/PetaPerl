package Sling::RcsbPdbDownload;

use File::Path;
use Sling::Configure;
use Sling::GpssFileTests; 
use Sling::Verbose;

##################################################################################
# rcsbPdbDownload
# 
# Author: T.A. Binkowski
# Date:   October 31, 2005
#
# Description: Downloads a zipped pdb file from PDB (Osaka), unzips it, and
#              places it in $filePath directory.  If $filePath is empty, then
#              it defaults to $CFG{'LOCAL_CAST'}
#
# Usage:       rcsbPdbDownload('1mbn', '');
#              rcsbPdbDownload('1mbn', '/Users/admin/');
#
##################################################################################
sub RcsbPdbDownload {

    my ($pdbId) = @_;

    my $pdbDir = substr($pdbId,1,2);
	
    #############################################################################
    # Get .pdb files
    #############################################################################
    if (!Sling::GpssFileTests::PdbFilesExist($pdbId)) {
	mkpath($CFG{'LOCAL_CAST'}.'/'.$pdbDir); # old school
	mkpath($CFG{'LOCAL_PDB'}.'/'.$pdbDir);
	$ftpFilePath = "ftp://ftp.wwpdb.org/pub/pdb/data/structures/divided/pdb/$pdbDir/pdb$pdbId.ent.gz";
	$localFilePath =  $CFG{'LOCAL_CAST'}."/$pdbDir/$pdbId.pdb.gz";
	`wget -nc -q -O $localFilePath $ftpFilePath`;
	system("gunzip $localFilePath");
	
	#$localFilePath =  $CFG{'LOCAL_PDB'}."/$pdbDir/$pdbId.pdb.Z";
	#`wget -nc -q -O $localFilePath $ftpFilePath`;
	#system("gunzip $localFilePath");
    } else {
	Sling::Verbose::Verbose("Sling::RcsbPdbDownload::RcsbPdbDownload -.pdb files exist\n");
      }

    #############################################################################
    # Get .xml files
    #############################################################################
    if (!Sling::GpssFileTests::XmlFilesExist($pdbId)) {
	mkpath($CFG{'LOCAL_XML'}.'/'.$pdbDir);
	# Get .xml-noatom files
	#$ftpFilePath = "ftp://ftp.rcsb.org/pub/pdb/data/structures/divided/XML-noatom/$pdbDir/$pdbId-noatom.xml.gz";
	#$localFilePath =   $CFG{'LOCAL_XML'}."/$pdbDir/$pdbId-noatom.xml.gz";
	#`wget -nc -q -O  $localFilePath $ftpFilePath`;
	#system("gunzip $localFilePath");
	
	# Get .xml (big) files
	#$ftpFilePath = "ftp://ftp.rcsb.org/pub/pdb/data/structures/divided/XML/$pdbDir/$pdbId.xml.gz";
	#$localFilePath =   $CFG{'LOCAL_XML'}."/$pdbDir/$pdbId.xml.gz";
	#`wget -nc -q -O  $localFilePath $ftpFilePath`;
	#system("gunzip $localFilePath");
    } else {
	Sling::Verbose::Verbose("Sling::RcsbPdbDownload::RcsbPdbDownload -.xml files exist\n");
      }
}

END {}
1;
