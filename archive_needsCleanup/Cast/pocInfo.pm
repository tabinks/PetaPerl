package Cast::pocInfo;
require Exporter;

use vars       qw($VERSION @ISA @EXPORT);
@ISA         = qw(Exporter);
@EXPORT      = qw(&pocInfo);

use vars       qw(@tmp $string %results);

$VERSION = 0.01;

sub pocInfo {

    my ($pdb,$pocket) = @_;
    my %results;
    $results{COUNT}=0;

    my $pdb_directory = substr(1,2,$pdb);
    open (POCINFO, "< /cast/$pdb_directory/$pdb.pocInfo") or
        die "Couldn't open /cast/$pdb_directory/$pdb.pocInfo:!$\n";

    while (<POCINFO>) {
        ($z,$z,$id,$n_mth,$a_sa,$a_ms,$v_sa,$v_ms,$len,$cnr) = split(/\s+/,$_);
        if ($id=~/\d/) {
            $results{$id}{n_mth} = $n_mth;
            $results{$id}{$id}   = $id;
            $results{$id}{a_sa}  = $a_sa;
            $results{$id}{a_ms}  = $a_ms;
            $results{$id}{v_sa}  = $v_sa;
            $results{$id}{v_ms}  = $v_ms;
            $results{$id}{len}   = $len;
            $results{$id}{cnr}   = $cnr;
            $results{COUNT}++;
        }
    }
    close POCINFO;

    return %results;
}

END { }      

1;
