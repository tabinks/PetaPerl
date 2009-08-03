package PetaPerl::Environment;

use base 'Exporter';

our @EXPORT    = qw(Date WhatIsMyIp Version System 
		    $_PETADOCK_HOME $_PETADOCK_SCRIPTS $_PETADOCK_TEMPLATES $_PETADOCK_BIN 
		    $_ZINC_HOME);

our $_PETADOCK_HOME="/home/abinkows/bin/PetaDock/";
our $_PETADOCK_SCRIPTS="/home/abinkows/bin/PetaDock/scripts/";
our $_PETADOCK_TEMPLATES="/home/abinkows/bin/PetaDock/templates/";
our $_PETADOCK_BIN="/home/abinkows/bin/PetaDock/bin/";
our $_ZINC_HOME="/pvfs-surveyor/abinkows/Libraries/zinc8/";


################################################################
# WhatIsMyIp
#    
#
################################################################
sub Date {
    my ($format) = @_;
    my $DATE = `date +%Y%m%d-%T`;
    chomp($DATE);
    return $DATE;
}

sub DateSimple {
    my ($format) = @_;
    my $DATE = `date +%Y%m%d`;
    chomp($DATE);
    return $DATE;
}

################################################################
################################################################
sub Version {

    my $PWD = `pwd`;chomp($PWD);
    chdir($_PETADOCK_HOME);

    my $git_description = qx{ git describe };
    my ( $RELEASE, $PATCH, $COMMIT ) = ( $git_description =~ /v([^-]+)-(\d+)-g(\w+)/ );
    $RELEASE .= ".$PATCH" if $PATCH;
    
    chdir($PWD);
    return "$RELEASE ($COMMIT)";
}

sub System {
    
    my $SYSTEM = substr($ENV{'PS1'},6,length($ENV{'PS1'})-11);
    if($SYSTEM) {
	return $SYSTEM;
    } elsif ($ENV{HOST}=~/tbinkowski/) {
	return $ENV{HOST};
    } else {
	return 'system-not-found';
    }
}

################################################################
################################################################
sub WhatIsMyIp {
    
    my @surveyor=("172.17.3.11",
                  "172.17.3.12",
                  "172.17.3.13",
                  "172.17.3.14",
                  "172.17.3.15",
                  "172.17.3.16"
                  );
    my @intrepid=("172.17.5.139",
                  "172.17.5.140",
                  "172.17.5.141",
                  "172.17.5.142",
                  "172.17.5.143",
                  "172.17.5.144"
                  );

    my $SYSTEM=System();
    my $hostname= $ENV{'HOSTNAME'};

    $hostname=~/login(\d)/;
    $number=$1-1;

    return $surveyor[$number] if ($SYSTEM eq "surveyor");
    return $intrepid[$number] if ($SYSTEM eq "intrepid");
    return "ip.was.not.found";
}

END {}
1;
