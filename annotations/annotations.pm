package para_split_and_merge::Test;

use Test::Class;
use base qw(Test::Class);
use Test::More;
use IO::All;
require "../common.pl";
require "../abicommand.pl";

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


sub simple1 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "simple1.abw", 
						"simple1.rnc", "" );

}

sub simple2 : Tests {

    TestDoubleConversionToODTWithRelaxNGSchema( "simple2.abw", 
						"simple2.rnc", "" );

}


sub LibreOfficeAnnotation : Tests {

    my $tmpdir = getTmpDir();
    Abiword_loadAndSave("LibreOfficeAnnotation.odt", "LibreOfficeAnnotation.abw");
    my $fn = TestDoubleConversionToODTWithRelaxNGSchema( "$tmpdir/LibreOfficeAnnotation.abw", 
							 "LibreOfficeAnnotation.rnc", "" );
    print "Last output odt file path: $fn\n";

    my $fnoo = LO_loadAndSave($fn,"loputput.odt");
    print "fnoo $fnoo\n";
    $fnoo = Abiword_loadAndSave("$fnoo", "LibreOfficeAnnotation2.abw");
    print "fnoo $fnoo\n";
    $fn = TestDoubleConversionToODTWithRelaxNGSchema( "$tmpdir/LibreOfficeAnnotation2.abw", 
						      "LibreOfficeAnnotation.rnc", "" );

}


sub annotationwithtitle : Tests {

    my $fn = TestDoubleConversionToODTWithRelaxNGSchema( "annotation-with-title.abw", 
							 "annotation-with-title.rnc", "" );

    print "annotationwithtitle ODT file: $fn\n";

    acrun();
    acsend("load $fn");

    acsend("rdf-execute-sparql \""
	   , "prefix pkg:  <http://docs.oasis-open.org/opendocument/meta/package/common#>"
	   , "prefix dc:   <http://purl.org/dc/elements/1.1/>"
	   , ""
	   , "select ?s ?id ?title where"
	   , "{"
	   , "  ?s pkg:idref ?id ."
	   , "  ?s dc:title ?title"
	   , "}\"" );
    acmatch("\n1\n#-----------------\n");
    acmatch("#-----------------\n"
	    . "id=anno1\n"
	    . "s=uri:bnode.*\n"
	    . "title=title1\n"
	    . "#-----------------\n");


}


sub dangling : Tests {

    my $tmpdir = getTmpDir();
    Abiword_loadAndSave("dangling.odt", "dangling.abw");
    my $fn = TestDoubleConversionToODTWithRelaxNGSchema( "$tmpdir/dangling.abw", 
							 "dangling.rnc", "" );
    print "Last output odt file path: $fn\n";
}


# Leave this here
1;
