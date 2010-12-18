use Test::More;
use IO::All;

#
# These are a bit of a problem as they might have to be
# changed on your machine or we need to make them test 
# for the files and change depending on the box.
#
$jing = "java -jar /usr/local/java/jing/bin/jing.jar";
$abiwordexe = "/tmp/abiword-install-odfct/bin/abiword";

#
# These should be OK without change on any Linux box
#
$uid = `id -u`;
chomp($uid);
$tmpdir = "/tmp/$uid/";
mkdir($tmpdir);
$getidxvar=1;


sub Abiword_loadAndSave {
    my $infile = shift;
    my $outfile = shift;
    my $outpath = "$tmpdir/$outfile";

    $outtype = $outfile;
    $outtype =~ s/.*\.([^.]+)/\1/g;
    $cmdline = "$abiwordexe -t $outtype -o $outpath $infile </dev/null >/dev/null 2>/dev/null";
    print "$cmdline\n";
    system( $cmdline );

    return $outpath;
};

sub Read_contentXml {
    my $infile = shift;
    $contents = io("unzip -q -p $infile content.xml |")->all;
    return $contents;
}

sub Extract_contentXml {
    my $infile = shift;
    system("unzip -q -o $infile -d $tmpdir");
    return "$tmpdir/content.xml";
}

sub getidx {
    $getidxvar++;
    return $getidxvar;
}


sub RunConversionAndVerifyRelaxNGSchema {
    my $infile = shift;
    my $schemafile = shift;
    my $errorMsg = shift;
    my $idx = getidx();

    my $outpath = Abiword_loadAndSave( $infile, "out$idx.odt" );
    my $contentFile = Extract_contentXml( $outpath );
    print "contentFile:$contentFile\n";
    system("$jing -c $schemafile $contentFile");
    $v = $?;
    ok( 0 == $v,
	"Schema check using $schemafile on $outpath, return code $v, msg: $errorMsg" );

    return $outpath;
}

sub TestDoubleConversionToODTWithRelaxNGSchema {
    my $infile = shift;
    my $schemafile = shift;
    my $errorMsg = shift;
    my $fn = "";

    $fn = RunConversionAndVerifyRelaxNGSchema( $infile, $schemafile,
					       "First conversion from abw to odf ($errorMsg)" );
    $fn = Abiword_loadAndSave( $fn, "out2.abw" );
    $fn = RunConversionAndVerifyRelaxNGSchema( $fn, $schemafile, 
					       "Second conversion from abw to odf ($errorMsg)" );
}


# Leave this here
1;
