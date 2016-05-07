# Module: DNS. See below for documentation.
# Copyright (C) 2010-2014 RedStone Development Group, et al.
# This program is free software; rights to this code are stated in doc/LICENSE.
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
