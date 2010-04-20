package Sling::Configure;

require Exporter;

@ISA         = qw(Exporter);
@EXPORT      = qw(%CFG %CMD);

use vars       qw(%CFG %CMD);

%CFG   = ( "VERBOSE" => 1,
	   "LOCAL_CAST" => "/Volumes/Xtbinkowski/sling/cast",
	   "LOCAL_PDB" => "/Volumes/Xtbinkowski/sling/pdb",
	   "LOCAL_XML" => "/Volumes/Xtbinkowski/sling/pdb",
	   "LOCAL_CONTRIB" => "/Volumes/Xtbinkowski/sling/contrib",
	   "LOCAL_DPC" => "/Volumes/Xtbinkowski/sling/dpc",
	   "LOCAL_HPC" => "/Volumes/Xtbinkowski/sling/hpc",
	   "LOCAL_CSA.MAP" => "/Volumes/Xtbinkowski/sling/csa.map",
	   "LOCAL_PPC" => "/Volumes/Xtbinkowski/sling/ppc",
	   "LOCAL_GPSS" => "/Volumes/Xtbinkowski/sling/gpss",
	   "LOCAL_SITES" => "/Volumes/Xtbinkowski/sling/sites",
	   "LOCAL_CSA" => "/Volumes/Xtbinkowski/sling/csa",
	   "LOCAL_LIGAND" => "/Volumes/Xtbinkowski/sling/ligand",
	   "LOCAL_BIN" => "/home/tbinkowski/projects/slingManage/bin",
	   "LOCAL_EC" => "/home/tbinkowski/projects/slingManage/ec",
	   #"LOCAL_WWW" => "/usr/local/apache/htdocs/slingManage",
	   "LOCAL_WWW" => "/Volumes/Xtbinkowski/sling/slingManage",
	   "LOCAL_EC2" => "/home/tbinkowski/projects/slingManage/ec/data/20070404.ec.identify.list",
	   "LOCAL_MMCIF" => "/home/tbinkowski/projects/slingManage/hpc/20070327/20070327.mmcif.hpc.list",
	   "SQLITE_DB" => "/Volumes/Xtbinkowski/sling/gpss/gpss.0.2.db",
	   "TMP" => "/tmp"
	   );


%CMD   = ( 
	   # Linux
	   "DELCX_LINUX" => $CFG{'LOCAL_BIN'}."/CASTp_linux_local/delcx.com ",
	   "MKALF_LINUX" => $CFG{'LOCAL_BIN'}."/CASTp_linux_local/mkalf.com ",
	   "VOLBL_LINUX" => $CFG{'LOCAL_BIN'}."/CASTp_linux_local/volbl.com ",
	   "FORCAST_LINUX" => 'perl '.$CFG{'LOCAL_BIN'}."/CASTp_linux_local/forcast.pl ",
	   "DIFF_LINUX" => 'perl '.$CFG{'LOCAL_BIN'}."/CASTp_linux_local/diff.pl ",
	   "PDB2GALF_LINUX" => 'perl '.$CFG{'LOCAL_BIN'}."/CASTp_linux_local/pdb2galf.pl ",
	   "CASTp_LINUX" => $CFG{'LOCAL_BIN'}."/CASTp_linux_local/cast.com ",
	   
	   "DELCX" => $CFG{'LOCAL_BIN'}."/delcx ",
	   "MKALF" => $CFG{'LOCAL_BIN'}."/mkalf ",
	   "VOLBL" => $CFG{'LOCAL_BIN'}."/volbl ",
	   "DIFF" => 'perl '.$CFG{'LOCAL_BIN'}."/diff.pl ",
	   "PDB2GALF" => 'perl '.$CFG{'LOCAL_BIN'}."/pdb2galf ",
	   "CASTp" => 'perl '.$CFG{'LOCAL_BIN'}."/CASTp_linux/CASTp_linux "
	   );

END {}
1;























