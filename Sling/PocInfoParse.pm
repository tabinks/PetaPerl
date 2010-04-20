###################################################################
# Change Log:
#             1/16/2006 Added sum field to sum all pocket values
#
###################################################################
package Sling::PocInfoParse;

use Sling::Configure;
use Sling::Trim;

sub PocInfoParse {
    
    my ($PDB,$PATH,$SUM) = @_;
    my $PDBDIR  = substr($PDB,1,2);
    
    # Set default path
    if ($PATH eq '') {
	$PATH = $CFG{'LOCAL_CAST'};
    } 
    $PDBPATH = $PATH."/$PDBDIR/$PDB.pocInfo"; 

    ######################################################
    # Set defaults
    ######################################################
    my %results = {};
    $results{1}{'N_MTH'} = "-";
    $results{1}{$id}   = "-";
    $results{1}{'A_SA'}  = "-";
    $results{1}{'A_MS'}  = "-";
    $results{1}{'V_SA'}  = "-";
    $results{1}{'V_MS'}  = "-";
    $results{1}{'LEN'}   = "-";
    $results{1}{'CNR'}   = "-";
    $results{COUNT}=0;
    
    ######################################################
    # Parse File
    ######################################################
    if (-e $PDBPATH) {
	open (POCINFO, "< $PDBPATH") or die "Couldn't open $file:!$\n";
	while (<POCINFO>) {
	    next if $_ =~ /Molecule/;
	    ($z,$z,$id,$n_mth,$a_sa,$a_ms,$v_sa,$v_ms,$len,$cnr) = split(/\s+/,$_);
	    $results{$id}{'N_MTH'} = $n_mth;
	    $results{$id}{$id}   = $id;
	    $results{$id}{'A_SA'}  = $a_sa;
	    $results{$id}{'A_MS'}  = $a_ms;
	    $results{$id}{'V_SA'}  = $v_sa;
	    $results{$id}{'V_MS'}  = $v_ms;
	    $results{$id}{'LEN'}   = $len;
	    $results{$id}{'CNR'}   = $cnr;
	    $results{'COUNT'}++;
	}
	close POCINFO;
    }

    # Sum all surfaces (used for hpc,dpc calculations where a contact
    # surface may be actually be > 1 CASTp pocket
    if ($SUM eq "SUM") {
	for $i (2..$results{'COUNT'}) {
	    $results{1}{'N_MTH'} += $results{$i}{'N_MTH'};
	    $results{1}{'A_SA'} += $results{$i}{'A_SA'};
	    $results{1}{'A_MS'} += $results{$i}{'A_MS'};
	    $results{1}{'V_SA'} += $results{$i}{'V_SA'};
	    $results{1}{'V_MS'} += $results{$i}{'V_MS'};
	}
    }
    
    # return 
    return %results;
}

END {}
1;
