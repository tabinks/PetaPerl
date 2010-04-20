package Discovery::Zinc;

use Discovery::Configure;
use Utilities::File;
use Utilities::Hash;
use DBI;

sub ZincId2Smiles {

    my ($zincId) = @_;
    $dbh = DBI->connect( "dbi:SQLite:".$CFG{'ZINC_DB'} ) or
	die "Cannot connect: $DBI::errstr";
    
    $p=$dbh->selectall_arrayref("SELECT smiles from zincProperties where zincId=='$zincId';");
    foreach (@$p) {
	return $_->[0];
    }
}

sub ZincId2Vendors {
    
    my ($zincId) = @_;
    $dbh = DBI->connect( "dbi:SQLite:".$CFG{'ZINC_DB'} ) or
	die "Cannot connect: $DBI::errstr";

    $tmp = '';
    $p=$dbh->selectall_arrayref("SELECT * from vendors where zincId=='$zincId';");
    foreach (@$p) {
	$tmp .= "    <vendor>\n";
	$tmp .= "     <vendor>".$_->[2]."</vendor>\n";
	$tmp .= "     <vendorId>".$_->[3]."</vendorId>\n";
	$tmp .= "     <www>".$_->[4]."</www>\n";
	$tmp .= "     <email>".$_->[5]."</email>\n";
	$tmp .= "     <phone>".$_->[6]."</phone>\n";
	$tmp .= "     <fax>".$_->[7]."</fax>\n";
	$tmp .= "    </vendor>\n";
    }
    return $tmp;
}







####################################################################
## ZincVendorHash
#
#
# This became obsolete one hour after writing it....
####################################################################
sub ZincVendorHash {

    my ($id) = @_;
    my %hash = {};

    open (FILE,"< $CFG{'ZINC_PURCHASING'}") or die "Couldn't open $CFG{'ZINC_PURCHASING'}\n";
    while (<FILE>) {
	next if $_ !~ /^ZINC/;
	chomp;
	($zincId,$supplier,$supplierCode,$website,$email,$phone,$fax) = split /\t/;
	$tmp = '';
	$tmp .= "    <vendor>\n";
	$tmp .= "     <vendor>$supplier</vendor>\n";
	$tmp .= "     <vendorId>$supplierCode</vendorId>\n";
	$tmp .= "     <www>$website</www>\n";
	$tmp .= "     <email>$email</email>\n";
	$tmp .= "     <phone>$phone</phone>\n";
	$tmp .= "     <fax>$fax</fax>\n";
	$tmp .= "    </vendor>";
	push @{ $hash{$zincId} }, $tmp;
    }
    #Utilities::Hash::HashPrintHashOfArrays(%hash);
    return %hash;
}

sub ZincVendorHashLookup {
    my ($zincId,%hash) = @_;
    my $returnString = '';

    #Utilities::Hash::HashPrintHashOfArrays(%hash);
    foreach $i (0..$#{ $hash{$zincId} } ) {
	$returnString .= "$hash{$zincId}[$i]\n";
    }
    return $returnString;
}

END {}
1;
