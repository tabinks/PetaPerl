package Tab::Output;

require Exporter;
use vars       qw($VERSION @ISA @EXPORT);

# set the version for version checking
$VERSION     = 0.01;

@ISA         = qw(Exporter);
@EXPORT      = qw(&PrintHash,&PrintHashOfHash);

sub PrintHashOfHash {
    my %tmp = @_;

    foreach $value (keys %tmp) {
	print "$value:\n";
	foreach $entry (keys %{$tmp{$value}}) {
	    printf("%15s",$entry);
	    print " =>   $tmp{$value}{$entry}\n";    
	}
    }
}

sub PrintHash {
    my %tmp = @_;

    while (($first,$last) = each(%tmp)) {
	print "$first => $last\n";
    }

}

sub NumberOfHashEntries {
    my %tmp = @_;
    my $i = 0;

    foreach $value (keys %tmp) {
	$i++;
    }
    print $i;
}

END { }      

1;
