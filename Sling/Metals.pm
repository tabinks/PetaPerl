package Sling::Metals;

require Exporter;

@ISA         = qw(Exporter);
@EXPORT      = qw(%Metals);

use vars       qw(%Metals);

%Metals   = ( 
	      #######################################################
	      # Sodium
	      #######################################################
	      'NA' => 'SODIUM',
	      'NA2'   =>  'SODIUM ION, 2 WATER COORDINATED',
	      'NA5'   =>  'SODIUM ION, 5 WATERS COORDINATED',
	      'NA6'   =>  'SODIUM ION, 6 WATERS COORDINATED',
	      'NAO'   =>  'SODIUM ION, 1 WATER COORDINATED',
	      'NAW'   =>  'SODIUM ION, 3 WATERS COORDINATED',

	      #######################################################
	      # Magnesium
	      #######################################################
	      'MG' => 'MAGNESIUM',
	      'MO1'   =>  'MAGNESIUM ION, 1 WATER COORDINATED',
	      'MO2'   =>  'MAGNESIUM ION, 2 WATERS COORDINATED',
	      'MO3'   =>  'MAGNESIUM ION, 3 WATERS COORDINATED',
	      'MO4'   =>  'MAGNESIUM ION, 4 WATERS COORDINATED',
	      'MO5'   => 'MAGNESIUM ION, 5 WATERS COORDINATED',
	      'MO6'   =>  'MAGNESIUM ION, 6 WATERS COORDINATED',

	      #######################################################
	      # Postassium
	      #######################################################
	      'K' => 'POTASSIUM',
	      'K04' => 'POTASSIUM ION, 4 WATERS COORDINATED',

	      #######################################################
	      # Calcium
	      #######################################################
	      'CA' => 'CALCIUM',
	      'OC1'   =>  'CALCIUM ION, 1 WATER COORDINATED',
	      'OC2'   =>  'CALCIUM ION, 2 WATERS COORDINATED',
	      'OC3'   =>  'CALCIUM ION, 3 WATERS COORDINATED',
	      'OC4'   =>  'CALCIUM ION, 4 WATERS COORDINATED',
	      'OC5'   =>  'CALCIUM ION, 5 WATERS COORDINATED',
	      'OC6'   =>  'CALCIUM ION, 6 WATERS COORDINATED',
	      'OC7'   =>  'CALCIUM ION, 7 WATERS COORDINATED',

	      #######################################################
	      # Iron
	      #######################################################
	      'FE' => 'IRON',

	      #######################################################
	      # Cobalt
	      #######################################################
	      'CO' => 'COBALT',
	      'CO5'   =>  'COBALT ION, 5 WATERS COORDINATED',
	      'OCL'   =>  'COBALT ION, 1 WATER COORDINATED',
	      'OCM'   =>  'COBALT ION, 3 WATERS COORDINATED',
	      'OCN'   =>  'COBALT ION, 2 WATERS COORDINATED',
	      'OCO'   =>  'COBALT ION, 6 WATERS COORDINATED',

	      #######################################################
	      # Zinc
	      #######################################################
	      'ZN' => 'ZINC',
	      'ZN3'   =>  'ZINC ION, 1 WATER COORDINATED',
	      'ZNO'   =>  'ZINC ION, 2 WATERS COORDINATED',
	      'ZO3'   =>  'ZINC ION, 3 WATERS COORDINATED',

	      #######################################################
	      # Gold
	      #######################################################
	      'AU' => 'GOLD',
	      'AU3'    =>  'GOLD 3+ ION',

	      #######################################################
	      # Nickel
	      #######################################################
	      'NI' => 'NICKEL',
	      'NI1'    =>  'NICKEL ION, 1 WATER COORDINATED',
	      'NI2'   =>  'NICKEL (II) ION, 2 WATERS COORDINATED',
	      'NI3'   =>  'NICKEL (II) ION, 3 WATERS COORDINATED',

	      #######################################################
	      # Copper
	      #######################################################
	      'CU' => 'COPPER',
	      '1CU'   =>  'COPPER ION, 1 WATER COORDINATED',

	      #######################################################
	      # Chloride
	      #######################################################
	      'CL' => 'CLORIDE ION',

	      'TE' => 'TELLURIUM',
	      'MO' => 'MOLYBDENUM',
	      'TL' => 'THALIUM',
	      'V' => 'VANADIUM',
	      'MO' => 'MOLYBDENUM',
	      'W' => 'TUNGSTEN',
	      'CR' => 'CHROMIUM',
	      'MN' => 'MANGANESE',
	      );

END {}
1;























