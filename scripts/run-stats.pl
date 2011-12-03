#!/usr/bin/env perl
use strict;
use warnings;
use POSIX;
my $APID;
use feature qw(say);
use English;
# Change this! This is the path to the pisg executable.
my $pisg = "/home/xelhua/pisg-0.72/pisg";

open STDIN, '<', '/dev/null' or say("Can't read /dev/null: $ERRNO");
open STDOUT, '>>', '/dev/null' or say("Can't write to /dev/null: $ERRNO");
open STDERR, '>>', '/dev/null' or say("Can't write to /dev/null: $ERRNO");
$APID = fork;
if ($APID != 0) {
    exit;
}
POSIX::setsid() or say("Can't start a new session: $ERRNO");

`$pisg`;