package para_split_and_merge::Test;

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



# sub test1 : Tests {
#     my $outpath = Abiword_loadAndSave( "para-add.abw", "out.odt" );
#     print "outpath:$outpath\n";
# #    my $contents = Read_contentXml($outpath);
# #    print "contents:$contents\n";

#     my $contentFile = Extract_contentXml( $outpath );
#     print "contentFile:$contentFile\n";
#     ok( 0 == system("$jing -c para-add.rnc $contentFile"), 
# 	"First conversion from abw to odf format ($?)" );

#     my $outpathABW = Abiword_loadAndSave( $outpath, "out2.abw" );
#     RunConversionAndVerifyRelaxNGSchema( $outpathABW, "para-add.rnc", 
# 					 "Second conversion from abw to odf" );
# };


sub test1 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "para-split.abw", "para-split.rnc", "" );

}


sub test2 : Tests {

    #
    # The paragraph before "three" is deleted (merging two\nthree into twothree)
    # and from e to e in fiv[e \n six \n se]ven inclusive is deleted.
    #
    TestDoubleConversionToODTWithRelaxNGSchema( "para-merge.abw", "para-merge.rnc", "" );

}

sub test3 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "paragraph-delete-startp2-through-startp3.abw", 
						"paragraph-delete-startp2-through-startp3.rnc", "" );

}


sub test4 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "paragraph-delete-startp2-through-startp4.abw", 
						"paragraph-delete-startp2-through-startp4.rnc", "" );

}


sub test5 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "delete-through-table.abw", 
						"delete-through-table.rnc", "" );

}

sub test6 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "delete-through-table-with-afterpara.abw", 
						"delete-through-table-with-afterpara.rnc", "" );

}

sub test7 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "delete-through-table-with-beforepara.abw", 
						"delete-through-table-with-beforepara.rnc", "" );

}


# Leave this here
1;
