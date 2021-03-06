package M::Portinfo;

use strict;
use warnings;
use API::Std qw(cmd_add cmd_del trans);
use API::IRC qw(privmsg notice);
use Socket;
use Regexp::Common qw/net/;

sub _init {
    cmd_add('PORTINFO', 0, 0, \%M::Portinfo::HELP_PORTINFO, \&M::Portinfo::cmd_portinfo) or return;
    
    return 1;
}

sub _void {
    cmd_del('PORTINFO') or return;
    
    return 1;
}

our %HELP_PORTINFO = (
	en => "Displays open ports on a given host. \2Syntax:\2 PORTINFO [host] [ports (seperated by comma's)]",
);

sub cmd_portinfo {
	my ($src, @argv) = @_;

	if (!defined $argv[0]) {
		notice($src->{svr}, $src->{nick}, trans('Not enough parameters').q{.});
		return;
	}

	my (@aPorts,@aWorking,$sPortList,$pSocket,$iPort);

    	if(lc($argv[1]) eq "irc")
    	{
	    	$sPortList = "443,994,6660,6661,6662,6663,6664,6665,6666,6667,6668,6669,6697,7000,7001,8000,9000,9999";
	    	$sPortList =~ s/,/ /g;
	    	@aPorts = split(/ /,$sPortList);    
    	}
    	elsif(lc($argv[1]) eq "proxy")
    	{
	   	$sPortList = "21,23,80,443,559,1027,1028,1029,3127,3128,3380,6300,8080,9001,9030,9031,9050";
	    	$sPortList =~ s/,/ /g;
	    	@aPorts = split(/ /,$sPortList);    
    	}
	else
	{
		$sPortList = $argv[1];
		$sPortList =~ s/,/ /g;
		@aPorts = split(/ /,$sPortList);
	}


	foreach $iPort (@aPorts) {
		$pSocket = IO::Socket::INET->new(PeerAddr => $argv[0], PeerPort => $iPort, Proto => 'tcp', Timeout => 4);
		if ($pSocket) {
			push (@aWorking, $iPort);
			$pSocket->close;
		}
	}

	if(@aWorking) {
		privmsg($src->{svr}, $src->{chan}, ">>> ".lc($argv[0])." has open ports: \002".join("\002, \002",@aWorking)."\002");
		privmsg($src->{svr}, $src->{chan}, ">>> Scanned ports: ".join(', ',@aPorts));
		return 1;
	} else {
		privmsg($src->{svr}, $src->{chan}, ">>> ".lc($argv[0])." has \002no open ports\002");
		privmsg($src->{svr}, $src->{chan}, ">>> Scanned ports: ".join(', ',@aPorts));
		return 0;
	}
}

API::Std::mod_init('Portinfo', 'Russell M Bradford (Converted to module by Chris Tyrrel)', '2.00', '3.0.0a11');

# build: perl=5.010000
