package PetaPerl::Configure;

require Exporter;

@ISA         = qw(Exporter);
@EXPORT      = qw(%CFG %CMD);

use vars       qw(%CFG %CMD);

%CFG   = ( "VERBOSE" => 1,
           "LOCAL_CAST" => "/net/Xtbinkowski/sling/cast",
           "LOCAL_CAST" => "/Volumes/Xtbinkowski/sling/cast",
           "LOCAL_PDB" => "/Volumes/Xtbinkowski/sling/pdb",
           "LOCAL_XML" => "/net/Xtbinkowski/sling/pdb",

           #"LOCAL_CONTRIB" => "/net/Xtbinkowski/sling/contrib",
           "LOCAL_CONTRIB" => "/net/Xtbinkowski/sling/Contrib", #2/2/2009

           "LOCAL_DPC" => "/net/Xtbinkowski/sling/dpc",
           #"LOCAL_HPC" => "/net/Xtbinkowski/sling/hpc",
           "LOCAL_HPC" => "/net/Xtbinkowski/sling/Gpss", #2/2/2009

           "LOCAL_CSA.MAP" => "/net/Xtbinkowski/sling/csa.map",
           "LOCAL_PPC" => "/net/Xtbinkowski/sling/ppc",
           "LOCAL_GPSS" => "/net/Xtbinkowski/sling/gpss",
           "LOCAL_SITES" => "/net/Xtbinkowski/sling/sites",
           "LOCAL_CSA" => "/net/Xtbinkowski/sling/csa",
           "LOCAL_LIGAND" => "/net/Xtbinkowski/sling/ligand",

           "LOCAL_BIN" => "/net/Xtbinkowski/Projects/slingManage/bin",
           "LOCAL_EC" => "/net/Xtbinkowski/Projects/slingManage/ec",
           #"LOCAL_WWW" => "/usr/local/apache/htdocs/slingManage",


           "LOCAL_WWW" => "/net/Xtbinkowski/sling/slingManage",
           "LOCAL_EC2" => "/home/tbinkowski/projects/slingManage/ec/data/20070404.ec.identify.list",
           "LOCAL_MMCIF" => "/home/tbinkowski/projects/slingManage/hpc/20070327/20070327.mmcif.hpc.list",
           "SQLITE_DB" => "/net/Xtbinkowski/sling/gpss/gpss.0.2.db",
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
