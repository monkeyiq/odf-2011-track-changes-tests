package deltamerge::Test;

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




sub testparacontentdeleted : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "para-content-deleted.abw", 
						"para-content-deleted.rnc", "" );
}

sub testparacontentdeletedthroughtonext : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "para-content-deleted-through-to-next.abw", 
						"para-content-deleted-through-to-next.rnc", "" );
}

sub testparacontentdeletedthroughtonext : Tests {
    TestDoubleConversionToODTWithRelaxNGSchema( "para-content-insert-delete-insert.abw", 
						"para-content-insert-delete-insert.rnc", "" );
}





# Leave this here
1;
