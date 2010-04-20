package Sling::Ions;

require Exporter;

@ISA         = qw(Exporter);
@EXPORT      = qw(%Metals);

use vars       qw(%Metals);

%Metals   = ( 'PO4' => 'Phosphate Ion',
	      'ZNO' => 'Zinc Ion, 2 Waters Coordinated'
	      );

END {}
1;























