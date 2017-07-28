use v6.c;
use Test;
use VimPlugger;

use-ok 'VimPlugger::datas';
use VimPlugger::datas;
my $datas = VimPlugger::datas.new("foobar.yml");
ok $datas, 'got datas';


use-ok 'VimPlugger::check';
use VimPlugger::check;

use-ok 'VimPlugger::install';
use VimPlugger::install;

use-ok 'VimPlugger::add';
use VimPlugger::add;

pass "replace me";

done-testing;
