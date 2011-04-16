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



sub teststylechange : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "style-change.abw", 
						"style-change.rnc", "" );
}

sub testparastylechange : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "paragraph-style-change.abw", 
						"paragraph-style-change.rnc", "" );
}

sub testparastylechangewh : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "paragraph-style-changes-with-headings.abw", 
						"paragraph-style-changes-with-headings.rnc", "" );
}

sub testparastylemanychanges : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "paragraph-style-many-changes.abw", 
						"paragraph-style-many-changes.rnc", "" );
}

sub testexample642 : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "example642.abw", 
						"example642.rnc", "" );
}

sub testtoboldandback : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "to-bold-and-back.abw", 
						"to-bold-and-back.rnc", "" );
}

sub testtoboldandbackflowing : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "to-bold-and-back-flowing.abw", 
						"to-bold-and-back-flowing.rnc", "" );
}

sub testtoboldandbackflowing2 : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "to-bold-and-back-flowing2.abw", 
						"to-bold-and-back-flowing2.rnc", "" );
}


sub testtobolditalandback : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "to-bold-italic-and-back-to-normal.abw", 
						"to-bold-italic-and-back-to-normal.rnc", "" );
}

sub testtobolditalandback2 : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "to-bold-italic-and-back-to-normal2.abw", 
						"to-bold-italic-and-back-to-normal2.rnc", "" );
}

sub testusinginternalstyles : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "using-internal-style-names.abw", 
						"using-internal-style-names.rnc", "" );
}



# Leave this here
1;
