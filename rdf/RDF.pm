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

    acsend("rdf-get-all-xmlids");
    acmatchline("intro,widetime,wingb,");

    acsend("rdf-get-xmlids");
    acmatchline("intro,");

    acsend("rdf-size");
    acmatchline("32");
    
    acsend("rdf-uri-to-prefixed http://docs.oasis-open.org/opendocument/meta/package/odf#attrB");
    acmatchline("odf:attrB");

    acsend("rdf-prefixed-to-uri odf:attrB");
    acmatchline("http://docs.oasis-open.org/opendocument/meta/package/odf\#attrB");

    acsend("rdf-uri-to-prefixed http://nothingmatches.com/foo#bar");
    acmatchline("http://nothingmatches.com/foo#bar");

    acsend("rdf-prefixed-to-uri thereisnoprefixforthis:foo");
    acmatchline("thereisnoprefixforthis:foo");

    acsend("rdf-context-show-objects uri:widetime http://www.w3.org/2002/12/cal/icaltzd#uid");
    acmatchline("uri:widetime");

    acsend("rdf-context-show-subjects http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://docs.oasis-open.org/opendocument/meta/package/odf#Element");
    acmatch("\nuri:example-element-1\nuri:example-element-2\nuri:widetime\nuri:wingb\n");

    acsend("rdf-context-contains uri:widetime http://www.w3.org/2002/12/cal/icaltzd#uid uri:widetime");
    acmatch("\n1\nOK\n");

    acsend("rdf-context-contains uri:wingb http://www.w3.org/2002/12/cal/icaltzd#uid uri:wingb");
    acmatch("\n1\nOK\n");

    # expected not to be there...
    acsend("rdf-context-contains a b c");
    acmatch("\n0\nOK\n");

    acsend("rdf-context-show-arcs-out uri:wingb");
    acmatch("http://docs.oasis-open.org/opendocument/meta/package/common#idref wingb\n"
	    . "http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://docs.oasis-open.org/opendocument/meta/package/odf#Element\n"
	    . "http://www.w3.org/1999/02/22-rdf-syntax-ns#type http://www.w3.org/2002/12/cal/icaltzd#Vevent\n" 
	    . "http://www.w3.org/2002/12/cal/icaltzd#dtend 2010-01-26T13:00:00\n"
	    . "http://www.w3.org/2002/12/cal/icaltzd#dtstart 2010-01-26T11:00:00\n"
	    . "http://www.w3.org/2002/12/cal/icaltzd#geo r1315195922r31762r2\n"
	    . "http://www.w3.org/2002/12/cal/icaltzd#summary Get your 11ses with tasty cakes before they all evaporate!\n"
	    . "http://www.w3.org/2002/12/cal/icaltzd#uid uri:wingb" );


    acsend("rdf-get-xmlid-range widetime");
    acmatchline("834 1012");

    acsend("movept 900");
    acsend("rdf-get-xmlids");
    acmatchline("widetime,");

    acsend("rdf-movept-xmlid-start wingb");
    acsend("showpt");
    acmatchline("995");

    acsend("rdf-get-xmlids");
    acmatchline("wingb,widetime,");

    # restricted view of all the RDF 
    acsend("rdf-set-context-model-xmlid widetime");
    acsend("rdf-dump");
    acmatch("s:uri:widetime p:http://www.w3.org/2002/12/cal/icaltzd#uid o:uri:widetime \nsize:8\n");

    # This is in the whole document as the above test has told us, 
    # however, it is not the restricted RDF model for widetime
    acsend("rdf-context-contains uri:wingb http://www.w3.org/2002/12/cal/icaltzd#uid uri:wingb");
    acmatch("\n0\nOK\n");

    acsend("rdf-context-contains uri:widetime http://www.w3.org/2002/12/cal/icaltzd#dtstart 2010-01-26T08:00:00");
    acmatch("\n1\nOK\n");

    # back to global model of all document RDF and test access again
    acsend("rdf-clear-context-model");
    acsend("rdf-size");
    acmatch("\n32\n");
    acsend("rdf-context-contains uri:wingb http://www.w3.org/2002/12/cal/icaltzd#uid uri:wingb");
    acmatch("\n1\nOK\n");


    # testing model-pos
    acsend("rdf-set-context-model-pos 996");
    acsend("rdf-dump");
    acmatch("s:uri:widetime p:http://www.w3.org/2002/12/cal/icaltzd#uid o:uri:widetime \nsize:16\n");

    acsend("rdf-set-context-model-pos 940");
    acsend("rdf-dump");
    acmatch("s:uri:widetime p:http://www.w3.org/2002/12/cal/icaltzd#uid o:uri:widetime \nsize:8\n");




}


#
# mutation that adds some triples 
#
sub test3add : Tests {

    acrun();
    acsend("load $fn");

    acsend("rdf-size");
    acmatch("\n32\n");

    acsend("rdf-mutation-create");
    acsend("rdf-mutation-add uri:subj1 uri:pred1 literalvalue1");
    acsend("rdf-mutation-add uri:subj2 uri:pred2 literalvalue2");
    acsend("rdf-mutation-add uri:subj2 uri:pred3 literalvalue3");
    acsend("rdf-mutation-add uri:subj2 uri:pred3 literalvalue4");
    acsend("rdf-mutation-commit");

    acsend("rdf-size");
    acmatch("\n36\n");

    acsend("rdf-context-contains uri:subj1 uri:pred1 literalvalue1");
    acmatch("\n1\nOK\n");
    acsend("rdf-context-contains uri:subj2 uri:pred3 literalvalue3");
    acmatch("\n1\nOK\n");

}

sub test4addrollback : Tests {

    acrun();
    acsend("load $fn");
    acsend("rdf-size");
    acmatch("\n32\n");

    acsend("rdf-mutation-create");
    acsend("rdf-mutation-add uri:subj1 uri:pred1 literalvalue1");
    acsend("rdf-mutation-add uri:subj2 uri:pred2 literalvalue2");
    acsend("rdf-mutation-add uri:subj2 uri:pred3 literalvalue3");
    acsend("rdf-mutation-add uri:subj2 uri:pred3 literalvalue4");

    acsend("rdf-mutation-rollback"); # <<---- we roll it back and revert.

    acsend("rdf-size");
    acmatch("\n32\n");

    acsend("rdf-context-contains uri:subj1 uri:pred1 literalvalue1");
    acmatch("\n0\nOK\n");
    acsend("rdf-context-contains uri:subj2 uri:pred3 literalvalue3");
    acmatch("\n0\nOK\n");
}


sub test5del : Tests {

    acrun();
    acsend("load $fn");
    acsend("rdf-size");
    acmatch("\n32\n");
    acsend("rdf-context-contains uri:wingb http://www.w3.org/2002/12/cal/icaltzd#uid uri:wingb");
    acmatch("\n1\nOK\n");
    acsend("rdf-context-contains uri:widetime http://www.w3.org/2002/12/cal/icaltzd#dtstart 2010-01-26T08:00:00");
    acmatch("\n1\nOK\n");

    acsend("rdf-mutation-create");
    acsend("rdf-mutation-remove uri:wingb http://www.w3.org/2002/12/cal/icaltzd#uid uri:wingb");
    acsend("rdf-mutation-commit");

    acsend("rdf-size");
    acmatch("\n31\n");
    acsend("rdf-context-contains uri:wingb http://www.w3.org/2002/12/cal/icaltzd#uid uri:wingb");
    acmatch("\n0\nOK\n");
    acsend("rdf-context-contains uri:widetime http://www.w3.org/2002/12/cal/icaltzd#dtstart 2010-01-26T08:00:00");
    acmatch("\n1\nOK\n");


    acsend("rdf-mutation-create");
    acsend("rdf-mutation-remove uri:widetime http://www.w3.org/2002/12/cal/icaltzd#dtstart 2010-01-26T08:00:00");
    acsend("rdf-mutation-rollback");
    
    acsend("rdf-size");
    acmatch("\n31\n");
    acsend("rdf-context-contains uri:widetime http://www.w3.org/2002/12/cal/icaltzd#dtstart 2010-01-26T08:00:00");
    acmatch("\n1\nOK\n");

}


sub test6sparql : Tests {

    acrun();
    acsend("load $fn");


    acsend('rdf-execute-sparql "select ?s ?p ?o where { ?s ?p ?o }"');
    acmatch("\n32\n#-----------------\n");
    acmatch("#-----------------\n"
	    . "o=http://docs.oasis-open.org/opendocument/meta/package/odf#Element\n"
	    . "p=http://www.w3.org/1999/02/22-rdf-syntax-ns#type\n"
	    . "s=uri:wingb\n"
	    . "#-----------------\n");

    
    acsend("rdf-execute-sparql \"select ?s ?p ?o where"
	   , "{  "
	   , "  ?s ?p ?o . "
	   , "  filter( str(?o) = 'wingb' ) "
	   , "}\"" );
    acmatch("\n1\n#-----------------\n");
    acmatch("\n#-----------------\n"
	    . "o=wingb\n"
	    . "p=http://docs.oasis-open.org/opendocument/meta/package/common#idref\n"
	    . "s=uri:wingb\n"
	    . "#-----------------\n" );

    
    # 8 results for this rdflink
    acsend("rdf-execute-sparql \""
	   , "prefix pkg:  <http://docs.oasis-open.org/opendocument/meta/package/common#> "
	   , "select ?s ?p ?o ?rdflink "
	   , "where {  "
	   , "  ?s ?p ?o . "
	   , "  ?s pkg:idref ?rdflink . "
	   , "  filter( str(?rdflink) = 'wingb' ) "
	   , "}\"" );
    acmatch("\n8\n#-----------------\n");
    acmatch("\n#-----------------\n"
	    . "o=2010-01-26T13:00:00\n"
	    . "p=http://www.w3.org/2002/12/cal/icaltzd#dtend\n" 
	    . "rdflink=wingb\n"
	    . "s=uri:wingb\n"
	    . "#-----------------\n"
	    . "o=2010-01-26T11:00:00\n"
	    . "p=http://www.w3.org/2002/12/cal/icaltzd#dtstart\n"
	    . "rdflink=wingb\n"
	    . "s=uri:wingb\n"
	    . "#-----------------\n");

    # two rdflinks at the same time.
    acsend("rdf-execute-sparql \""
	   , "prefix pkg:  <http://docs.oasis-open.org/opendocument/meta/package/common#> "
	   , "select ?s ?p ?o ?rdflink "
	   , "where {  "
	   , "  ?s ?p ?o . "
	   , "  ?s pkg:idref ?rdflink . "
	   , "  filter( str(?rdflink) = 'wingb' || str(?rdflink) = 'widetime' ) "
	   , "}\"" );
    acmatch("\n16\n#-----------------\n");
    acmatch("\n#-----------------\n"
	    . "o=2010-01-26T13:00:00\n"
	    . "p=http://www.w3.org/2002/12/cal/icaltzd#dtend\n" 
	    . "rdflink=wingb\n"
	    . "s=uri:wingb\n"
	    . "#-----------------\n" );
    acmatch("\n#-----------------\n"
	    . "o=widetime\n"
	    . "p=http://docs.oasis-open.org/opendocument/meta/package/common#idref\n"
	    . "rdflink=widetime\n"
	    . "s=uri:widetime\n"
	    . "#-----------------\n" );




# rdf-execute-sparql "
# prefix pkg:  <http://docs.oasis-open.org/opendocument/meta/package/common#> 
# select ?s ?p ?o ?rdflink 
# where {  
#   ?s ?p ?o . 
#   ?s pkg:idref ?rdflink . 
#   filter( str(?rdflink) = 'wingb' || str(?rdflink) = 'widetime' ) 
# }
# "


}

    # TODO
    #
    # more complex sparql queries?
    # ins / del xmlid
    # rdf-import  rdf-export  
    #



# Leave this here
1;
