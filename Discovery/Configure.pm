package Discovery::Configure;

require Exporter;

@ISA         = qw(Exporter);
@EXPORT      = qw(%CFG %CMD);

use vars       qw(%CFG %CMD);

%CFG   = ( "VERBOSE" => 1,
	   "TMP" => "/tmp/",

	   "CHEMBANK_IMAGES" => "/net/Xtbinkowski/discovery/chembank/images",
	   "CHEMBANK_DB" => "/net/Xtbinkowski/discovery/chembank/chembank.20060601.db",

	   "DAYLIGHT_IMAGES" => "/net/Xtbinkowski/discovery/daylight/images",
	   "HARVARD_IMAGES" => "/net/Xtbinkowski/discovery/harvard/images",
	   "MOL2GIF" => "/usr/local/openeye/bin/mol2gif",
	   "OE_FILTER" => "/usr/local/openeye/bin/filter",


	   "MSDCHEM_SMILES" => "/net/Xtbinkowski/discovery/msdchem/msdchem.smi",
	   "MSDCHEM_IMAGES" => "/net/Xtbinkowski/discovery/msdchem/images",

	   "ZINC_DB" => "/net/Xtbinkowski/discovery/zinc/zinc2.db",
	   "ZINC_IMAGES" => "/net/Xtbinkowski/discovery/zinc/images",
	   "ZINC_PROPERTIES" => "/net/Xtbinkowski/discovery/zinc/properties/zincProperties.db",
	   "ZINC_PURCHASING" => "/net/Xtbinkowski/discovery/zinc/all-purchasable/all-purchasable.20040816.pinfo"
	   );


%CMD   = ( 
	   # Linux
	   "DELCX_LINUX" => $CFG{'LOCAL_BIN'}."/CASTp_linux/delcx.com ",
	   "MKALF_LINUX" => $CFG{'LOCAL_BIN'}."/CASTp_linux/mkalf.com ",
	   "VOLBL_LINUX" => $CFG{'LOCAL_BIN'}."/CASTp_linux/volbl.com ",
	   "FORCAST_LINUX" => 'perl '.$CFG{'LOCAL_BIN'}."/CASTp_linux/forcast.pl ",
	   "DIFF_LINUX" => 'perl '.$CFG{'LOCAL_BIN'}."/CASTp_linux/diff.pl ",
	   "PDB2GALF_LINUX" => 'perl '.$CFG{'LOCAL_BIN'}."/CASTp_linux/pdb2galf.pl ",
	   "CASTp_LINUX" => $CFG{'LOCAL_BIN'}."/CASTp_linux/cast.com ",
	   
	   "DELCX" => $CFG{'LOCAL_BIN'}."/delcx ",
	   "MKALF" => $CFG{'LOCAL_BIN'}."/mkalf ",
	   "VOLBL" => $CFG{'LOCAL_BIN'}."/volbl ",
	   "DIFF" => 'perl '.$CFG{'LOCAL_BIN'}."/diff.pl ",
	   "PDB2GALF" => 'perl '.$CFG{'LOCAL_BIN'}."/pdb2galf ",
	   "CASTp" => 'perl '.$CFG{'LOCAL_BIN'}."/CASTp_linux/CASTp_linux "
	   );

END {}
1;























