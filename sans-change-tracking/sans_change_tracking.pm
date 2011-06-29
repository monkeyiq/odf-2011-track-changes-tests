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

    TestDoubleConversionToODTWithRelaxNGSchema( "simple1.abw", 
						"simple1.rnc", "" );

}


sub test2 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "simpletable.abw", 
						"simpletable.rnc", "" );

}


sub test3 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "image.abw", 
						"image.rnc", "" );

}

sub test4 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "bullets-and-styles.abw", 
						"bullets-and-styles.rnc", "" );

}




# Leave this here
1;
