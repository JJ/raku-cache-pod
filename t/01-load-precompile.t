use Test;

use nqp;
use File::Directory::Tree;
use Pod::To::Cache;

constant cache-dir = "cache/";
constant doc-dir = "t/doctest/";

my $cache = Pod::To::Cache.new(:doc-dir(doc-dir), :cache-dir(cache-dir));

for <simple sub/simple> -> $doc-name {
    is-deeply $cache.pod(:pod-name($doc-name)), $=pod[0], "Load precompiled pod $doc-name";
    #that regex matchs a sha1 name
    my @dirs = dir( "cache/", test => /<[A..Z 0..9]> ** 5..40/);
    is @dirs.elems, 1, "Cached dir created";
    my $key = nqp::sha1(doc-dir~$doc-name~".pod6");
    my $dir = @dirs[0] ~ "/" ~ $key.substr(0,2);
    ok $dir.IO.d, "Key directory created";
    ok "$dir/$key".IO.f, "File cached";
}

rmtree(cache-dir);

done-testing;

=begin pod

=TITLE Powerful cache

Raku is quite awesome.

=end pod