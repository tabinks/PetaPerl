package PetaPerl::Log;

use PetaPerl::Environment;

################################################################
# WhatIsMyIp
#    
#
################################################################
sub About {
    my ($FILEHANDLE)=shift;
    my @ARGS=@_;

    my $CMD=$0;foreach(@ARGS){$CMD.=" $_";}
    my $PWD=`pwd`;chomp($PWD);
    my $SYSTEM  = System();
    my $IP      = PetaPerl::Environment::WhatIsMyIp();
    my $VERSION = PetaPerl::Environment::Version();
    my $DATE    = PetaPerl::Environment::Date();

    $STDOUT_FLAG=(-e $FILEHANDLE) ? 1 : 0;
    PetaPerl::Log::Status($FILEHANDLE,1,"PetaDock - gridPrep");
    PetaPerl::Log::Log($FILEHANDLE,1,"Run By:\t\t".$ENV{'USER'});
    PetaPerl::Log::Log($FILEHANDLE,1,"Date:\t\t$DATE");;
    PetaPerl::Log::Log($FILEHANDLE,1,"System:\t\t$SYSTEM ($IP)");
    PetaPerl::Log::Log($FILEHANDLE,1,"Pwd:\t\t$PWD");
    PetaPerl::Log::Log($FILEHANDLE,1,"Version:\t$VERSION");
    PetaPerl::Log::Log($FILEHANDLE,1,"Command:\t$CMD");
    
    PetaPerl::Log::Status($FILEHANDLE,1,"Working Paths");
    PetaPerl::Log::Log($FILEHANDLE,1,"PWD:\t$PWD");  
}
################################################################
################################################################
sub Log {

    my ($FILEHANDLE,$STDOUT,$STRING,) = @_;   
    print "$STRING\n" if $STDOUT;
    print $FILEHANDLE "$STRING\n";
}

sub Status {

    my ($FILEHANDLE,$STDOUT,$STRING,) = @_;
    
    if($STDOUT==1) {
	print "\n";
	for($i=0;$i<80;$i++) { print "#"; }
	print "\n";
	print "## $STRING\n";
	for($i=0;$i<80;$i++) { print "#";}
	print "\n";
    }
    
    # Print to log
    print $FILEHANDLE "\n";
    for($i=0;$i<80;$i++) { print $FILEHANDLE "#"; }
    print $FILEHANDLE "\n";
    print $FILEHANDLE "## $STRING\n";
    for($i=0;$i<80;$i++) { print $FILEHANDLE "#";}
    print $FILEHANDLE "\n";
}

END {}
1;
