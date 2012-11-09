use strict;
use Test::More;
use t::Redis;

test_redis sub {
    my ($r, $port, $server) = @_;

    my $info = $r->info->recv;
    ok $info->{redis_version}, "initial command";

    $server->stop;
    $server->start;

    my $cv = AE::cv;

    $cv->begin;

    $r->info(sub {
      my $info = shift;
      ok $info->{redis_version}, "reconnect command";
      $cv->end;
    });

    $cv->begin;

    $r->info(sub {
      my $info = shift;
      ok $info->{redis_version}, "reconnect command";
      $cv->end;
    });

    $cv->recv;
}, { reconnect => 1 };

done_testing;
