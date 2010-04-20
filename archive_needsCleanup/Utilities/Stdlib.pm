package Tab::Stdlib;

require Exporter;
# set the version for version checking
$VERSION     = 0.01;

sub sizeof() {
    return $#_;
}

END { }      

1;
