package RDF::Test;

use Test::Class;
use base qw(Test::Class);
use Test::More;
use IO::All;
require "../common.pl";
require "../abicommand.pl";

$fn = "";

# once per whole run
sub startup : Test(startup) {

    $fn = acprepdoc("multi2011sep.odt");
    acrun();

}

# setup methods are run before every test method. 
sub make_fixture : Test(setup) {
    shift->{foo} = "bar";
}

# teardown methods are run after every test method.
sub teardown : Test(teardown) {
    my $foo = shift->{foo};
    diag("\nall tests are done.... cleanup\n");
    diag("foo = ($foo) after test(s)");
};


sub test1 : Tests {

    acsend("help");
    $txt = acget();
    acmatch("RDF subsystem");

}

sub test2 : Tests {

    acrun();
    acsend("load $fn");

    # acsend("rdf-get-all-xmlids");
    # acmatchline("intro,widetime,wingb,");


}





# Leave this here
1;
