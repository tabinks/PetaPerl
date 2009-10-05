package PetaPerl::Environment;

use base 'Exporter';
use Socket;
use Sys::Hostname;

@EXPORT = qw(Date WhatIsMyIp Version System EnvironmentDump
	     $_PETADOCK_HOME $_PETADOCK_SCRIPTS $_PETADOCK_TEMPLATES $_PETADOCK_BIN 
	     $_ZINC_HOME %PETAPERL_ENV);

use vars       qw(%PETAPERL_ENV);

our $_PETADOCK_HOME="/home/abinkows/bin/PetaDock/";
our $_PETADOCK_SCRIPTS="/home/abinkows/bin/PetaDock/scripts/";
our $_PETADOCK_TEMPLATES="/home/abinkows/bin/PetaDock/templates/";
our $_PETADOCK_BIN="/home/abinkows/bin/PetaDock/bin/";
our $_ZINC_HOME="/pvfs-surveyor/abinkows/Libraries/zinc8/";

our %PETAPERL_ENV = ("OSTYPE" => $ENV{"OSTYPE"},
		     "VENDOR" => $ENV{"VENDOR"},
		     "USER"   => $ENV{"USER"}
    );

sub _Initialize {
    Date();
    DateSimple();
    Version();
    System();
    WhatIsMyIp();
}
################################################################
# WhatIsMyIp
#    
#
################################################################
sub Date {
    my ($format) = @_;
    my $DATE = `date +%Y%m%d-%T`;
    chomp($DATE);
    $PETAPERL_ENV{'DATE'} = $DATE;
    return $DATE;
}

sub DateSimple {
    my ($format) = @_;
    my $DATE = `date +%Y%m%d`;
    chomp($DATE);
    $PETAPERL_ENV{'DATE_SIMPLE'} = $DATE;
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
    $PETAPERL_ENV{'VERSION'} = "$RELEASE ($COMMIT)";
    return "$RELEASE ($COMMIT)";
}

sub System {
    my $system = 'system-not-found';

    my $SYSTEM = substr($ENV{'PS1'},6,length($ENV{'PS1'})-11);
    if($SYSTEM) {
	$system = $SYSTEM;
    } elsif ($ENV{HOST}=~/tbinkowski/) {
	$system = $ENV{HOST};
    }
    $PETAPERL_ENV{'SYSTEM'} = $system;
    return $system;
}

################################################################
################################################################
sub WhatIsMyIp {
    
    my $ip = "ip.was.not.found";
    my @surveyor=("172.17.3.11","172.17.3.12",
                  "172.17.3.13","172.17.3.14",
                  "172.17.3.15","172.17.3.16"
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
    
    if($hostname=~/login(\d)/) {
	$number=$1-1;
	$ip = $surveyor[$number] if ($SYSTEM eq "surveyor");
	$ip = $intrepid[$number] if ($SYSTEM eq "intrepid");
    } else {
	my $host = hostname();
	my $addr = inet_ntoa(scalar(gethostbyname($host)) || 'localhost');
	$PETAPERL_ENV{'IP'} = $addr;
    }
    return $ip;
}

sub EnvironmentDump {
    _Initialize();
    foreach $k (sort keys %PETAPERL_ENV) {
	print "$k\t\t\t=>\t$PETAPERL_ENV{$k}";
	print "\n";
    }
}

## Standard Module End
END {}
1;
