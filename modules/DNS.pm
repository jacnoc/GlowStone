# Module: DNS. See below for documentation.
# Copyright (C) 2010-2014 RedStone Development Group, et al.
# This program is free software; rights to this code are stated in doc/LICENSE.
package M::DNS;
use strict;
use warnings;
use API::Std qw(cmd_add cmd_del trans);
use API::IRC qw(privmsg notice);
use Net::DNS;

# Initialization subroutine.
sub _init {
    # Create the DNS command.
    cmd_add('DNS', 0, 0, \%M::DNS::HELP_DNS, \&M::DNS::cmd_dns) or return;

    # Success.
    return 1;
}

# Void subroutine.
sub _void {
    # Delete the DNS command.
    cmd_del('DNS') or return;

    # Success.
    return 1;
}

# Help hash.
our %HELP_DNS = (
    en => "This command will do a DNS lookup. \2Syntax:\2 DNS <host>",
);

# Callback for DNS command.
sub cmd_dns {
    my ($src, @argv) = @_;
     
    if (!defined $argv[0]) {
        notice($src->{svr}, $src->{nick}, trans('Not enough parameters').q{.});
        return;
    }
    my $res = Net::DNS::Resolver->new;
	my $res2 = Net::DNS::Resolver->new;
	my $res3 = Net::DNS::Resolver->new;
	$res->force_v4(1);
	$res2->force_v4(0);
	$res->tcp_timeout(3);
	$res2->tcp_timeout(3);
	$res3->tcp_timeout(3);
	$res3->udp_timeout(3);
	$res2->udp_timeout(3);
	$res->udp_timeout(3);
	my $query = $res->search(strip_colorcodes($argv[0]),'A');
	my $query2 = $res2->search(strip_colorcodes($argv[0]),'AAAA');
	my $query3 = $res3->search(strip_colorcodes($argv[0]));
	my $v4 = 0;
	my $v6 = 0;
	my $rd = 0;
	my @results;
	my @resultt;
	my @resultu;

	if ($query) {
		foreach my $rr ($query->answer) {
    			next if $rr->type ne 'A';
    			push(@results, $rr->address);
    			$v4++;
		}
	}
	else {
		$v4 = 0;
	}

	if ($query2) {
		foreach my $rr2 ($query2->answer) {
    			next if $rr2->type ne 'AAAA';
    			push(@resultt, $rr2->address);
    			$v6++;
		}
	}
	else {
		$v6 = 0;
	}

	if ($query3) {
		foreach my $rr3 ($query3->answer) {
    			next if $rr3->type ne 'PTR';
    			push(@resultu, $rr3->rdatastr);
    			$rd++;
		}
	}
	else {
		$rd = 0;
	}

	if($v4 == 0 && $v6 == 0 && $rd == 0)
	{
		privmsg($src->{svr}, $src->{chan}, "No results found for \2$argv[0]\2.");
		return;
	}
	else
	{

		if($v4 > 50)
		{
			privmsg($src->{svr}, $src->{chan}, 'Too many results were returned..');
			return;
		}
		if($v6 > 50)
		{
        		privmsg($src->{svr}, $src->{chan},'Too many results were returned..');
        		return;
		}
		if($rd > 50)
		{
        		privmsg($src->{svr}, $src->{chan}, 'Too many results were returned..');
        		return;
		}


		privmsg($src->{svr}, $src->{chan}, "Results for \2$argv[0]\2:");

		if (@results) {
			my $result = join ' ', @results;
			privmsg($src->{svr}, $src->{chan}, "IPv4 Results (".scalar(@results)."): ".$result);
		}
		if (@resultt) {
        		my $result = join ' ', @resultt;
        		privmsg($src->{svr}, $src->{chan}, "IPv6 Results (".scalar(@resultt)."): ".$result);
		}
		if (@resultu) {
        		my $result = join ' ', @resultu;
        		privmsg($src->{svr}, $src->{chan}, "RDNS Results (".scalar(@resultu)."): ".$result);
		}

	}
	
	return;

    return 1;
}

# Start initialization.
API::Std::mod_init('DNS', 'Xelhua', '1.01', '3.0.0a11');
# build: cpan=Net::DNS perl=5.010000

__END__

=head1 NAME

DNS - Net::DNS interface.

=head1 VERSION

 1.00

=head1 SYNOPSIS

 <matthew> !dns ethrik.net
 <blue> Results for ethrik.net:
 <blue> Results (1): 217.114.62.164

=head1 DESCRIPTION

This module creates the DNS command for preforming DNS
lookups.

=head1 DEPENDENCIES

This module depends on the following CPAN modules:

=over

=item L<Net::DNS>

This is the DNS agent this module uses.

=back

=head1 AUTHOR

This module was written by Matthew Barksdale.

This module is maintained by RedStone Development Group.

=head1 LICENSE AND COPYRIGHT

This module is Copyright 2010-2014 RedStone Development Group.

Released under the same licensing terms as RedStone itself.

=cut

# vim: set ai et sw=4 ts=4:
