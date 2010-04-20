package Sling::XtalArtifacts;

require Exporter;

@ISA         = qw(Exporter);
@EXPORT      = qw(%XtalArtifacts);

use vars       qw(%XtalArtifacts);

%XtalArtifacts   = ( 'MSE' => 'selenomethionine',
		     'EGL' => 'ethylene glycol',
		     'TRS' => 'tris buffer',
		     'GOL' => 'glycerol',
		     'BME' => 'beta-mercaptoethanol',
		     'SEO' => '2-mercaptoethanol'
		     );

END {}
1;























