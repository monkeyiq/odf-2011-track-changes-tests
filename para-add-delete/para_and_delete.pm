package para_and_delete::Test;

use Test::Class;
use base qw(Test::Class);
use Test::More;
use IO::All;
require "../common.pl";

# once per whole run
sub startup : Test(startup) {

}

# setup methods are run before every test method. 
sub make_fixture : Test(setup) {
    shift->{foo} = "bar";
}

# teardown methods are run after every test method.
sub teardown : Test(teardown) {
    my $foo = shift->{foo};
    diag("foo = ($foo) after test(s)");
};

sub alwaysgood : Tests {
    is( 1, 1, "the world is sane");
};


sub test1 : Tests {
    my $outpath = Abiword_loadAndSave( "para-add.abw", "out.odt" );
    print "outpath:$outpath\n";
#    my $contents = Read_contentXml($outpath);
#    print "contents:$contents\n";

    my $contentFile = Extract_contentXml( $outpath );
    print "contentFile:$contentFile\n";
    ok( 0 == system("$jing -c para-add.rnc $contentFile"), 
	"First conversion from abw to odf format ($?)" );

    my $outpathABW = Abiword_loadAndSave( $outpath, "out2.abw" );
    RunConversionAndVerifyRelaxNGSchema( $outpathABW, "para-add.rnc", 
					 "Second conversion from abw to odf" );
};


sub test2 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "para-delete.abw", "para-delete.rnc", "" );

}



# Leave this here
1;
