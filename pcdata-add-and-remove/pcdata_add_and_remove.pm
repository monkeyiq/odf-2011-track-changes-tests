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




sub test1 : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "text-insert.abw", "text-insert.rnc", "" );
}

sub test2 : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "text-insert-and-new-para.abw", "text-insert-and-new-para.rnc", "" );
}

sub test3 : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "text-remove.abw", "text-remove.rnc", "" );
}

sub test4 : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "text-remove-with-tables.abw", 
						"text-remove-with-tables.rnc", "" );
}


# Leave this here
1;
