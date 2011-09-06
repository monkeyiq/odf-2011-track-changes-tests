#
# author:   Ben Martin
# created:  Mon Sep  5, 2011
#
# This module spawns an abicommand session and runs your commands returning the results
# OK/Not 
#


use Expect::Simple;
use File::Copy "cp";
use File::Basename;

$exp = 0;
$res = "";
$lastcmd = "";

sub tempxfilename() {
    my $idx = getidx();
    my $outpath = "$tmpdir/outfile-$idx";
    return $outpath;
}

sub tempodtfilename($) {
    my $tfn = tempxfilename();
    my $outpath = "$tfn.odt";
    return $outpath;
}

sub temprdffilename($) {
    my $tfn = tempxfilename();
    my $outpath = "$tfn.rdf";
    return $outpath;
}


sub acprepdoc($) {
    my $infile = shift;
    my $outfile = basename($infile);
    my $outpath = "$tmpdir/$outfile";
    cp( $infile, $outpath );
    return $outpath;
}
sub acrun($) {
    my $arg = shift;
    if( $exp ) {
	#
    }
    $exp = new Expect::Simple 
    { Cmd => [ "/tmp/abiword-trunk-install/bin/abiword", "--plugin", "AbiCommand" ],
      Prompt => [ -re => 'AbiWord:>\s+' ],
      DisconnectCmd => 'q',
      Verbose => 1,
      Debug => 0,
      Timeout => 5 # 100
    };

}

sub acsend($) {
    my $cmd = join(" ",@_);
    $exp->send( $cmd );
    $lastcmd = $cmd;

    ($res = $exp->before);
    $res =~ tr/\r//d;
    ok( $res =~ "\nOK\n", 
	"AbiCommand 'OK' for cmd:$cmd" );
    $res =~ "\nOK\n" or diag("result read back was:$res");
    return $exp->error == undef;
}


sub acget($) {
    return $res;
}

sub acmatch($) {
#    my $rex = join("",@_);
    my $rex = shift;
    my $msg = shift;

#    print("rex:$rex\n");
    ok( $res =~ "$rex", 
	"AbiCommand result match rex:$rex lastcmd:$lastcmd" );
    $res =~ "$rex" or diag("rex:$rex got:$res\ndebug message:$msg");
    
}

sub acmatchline($) {
    my $rex = shift;
    my $msg = shift;
    $v = acmatch( "\n$rex\n" );
}

# Leave this here
1;
