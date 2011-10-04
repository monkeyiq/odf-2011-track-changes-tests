package RDF::Test;

use Test::Class;
use base qw(Test::Class);
use Test::More;
use IO::All;
require "../common.pl";
require "../abicommand.pl";

use Expect;

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

    acsend("movept BOD");
    acsend("movept 995");
    acsend("selectstart");
    acsend("movept 1010");
    acsend("selectcopy");
    acsend("movept EOD");

    acsend("startnewparagraph");
    acsend("startnewparagraph");
    acsend("inserttext end of original document...");
    acsend("startnewparagraph");
    acsend("startnewparagraph");
    acsend("paste");
    acsend("save /tmp/out.odt");

    #
    # check to make sure that the pasted text:meta has an identifier
    # like x-wingb-`uuid`
    #
    acsend("movept 1192");
    acsend("rdf-get-xmlids");
    acmatchline("x-wingb-[a-f0-9-]+,");


}


#
# copy and paste with RDF across abiword process boundary
#
sub test3 : Tests {

    use IO::Handle;
    pipe(CHILD_RDR, PARENT_WTR);
    PARENT_WTR->autoflush(1);

    $outpath = "/tmp/out.odt";
    my $pid = fork();
    if (not defined $pid) {
	print "fork() resources not avilable.\n";
    } elsif ($pid == 0) {

 	print "I AM THE CHILD\n";
	# wait for parent to be ready for our clipboard request...
	chomp($line = <CHILD_RDR>);
 	print "CHILD IS NOW STARTING TO RUN\n";
	acrun();
	acsend("new");
	acsend("paste");
	# acsend("inserttext foo2");
	acsend("save $outpath");
	acsend("help");
    }
    else
    {
	print "I AM THE PARENT\n";

	# parent has to be inside gtk_main for copy to be performed
	# by child process
	acrun();
	acsend("load $fn");
	acsend("movept BOD");
	acsend("movept 995");
	acsend("selectstart");
	acsend("movept 1010");
	acsend("selectcopy");
	print PARENT_WTR "Child can go now...\n";
	acsend( "run 10" );
	$p = waitpid($pid, 0);
    }

    # Verify /tmp/out.odt 
    # content.xml has Wing-B at 11am in a text:meta with xml:id="wingb"
    # and that there are the desired RDF triples in the manifest.rdf file
    $tfn = Extract_fromODF($outpath,"manifest.rdf");
    $c      = RDFXMLFile_Count("$tfn");
    $rdfxml = RDFXMLFile_Cat("$tfn");
    ok( $c == 16, "copy and paste with RDF triples following, interprocess test, wanted 16 got $c  RDF/XML file:$tfn");
    like( $rdfxml,
	  qr@<uri:widetime> <http://docs.oasis-open.org/opendocument/meta/package/common#idref> "widetime" .@,
	  "exported RDF/XML contains expected triple" );

    $contentFile = Extract_contentXml( $outpath );
    $schemafile = "cross-document-post.rnc";
    VerifyRelaxNGSchema( $contentFile, $schemafile, 
			 "cross document copy and paste text:meta and content.xml verification" );

}



# Leave this here
1;
