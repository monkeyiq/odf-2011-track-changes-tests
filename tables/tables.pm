package tables::Test;

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



sub testinsert : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "insert-table.abw", "insert-table.rnc", "" );
}

sub testdelete : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "delete-table.abw", "delete-table.rnc", "" );
}

sub testwholetablewithleadingtrailing : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "delete-whole-table-with-leading-and-trailing.abw", 
						"delete-whole-table-with-leading-and-trailing.rnc", "" );
}

sub testtablecellcontentedited : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "table-cell-content-edited.abw", 
						"table-cell-content-edited.rnc", "" );
}



# Leave this here
1;
