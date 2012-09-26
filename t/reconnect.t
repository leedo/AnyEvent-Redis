use strict;
use Test::More;
use t::Redis;

test_redis {
    my ($r, $port, $server) = @_;

    my $info = $r->info->recv;
    ok $info->{redis_version}, "initial command";

    $server->stop;
    $server->start;

    my $cv = AE::cv;

    $info = $r->info->recv;
    ok $info->{redis_version}, "reconnect command";

};

done_testing;
