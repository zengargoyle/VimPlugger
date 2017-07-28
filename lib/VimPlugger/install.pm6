#---install.pm---
unit module VimPlugger::install;
#use Prompt::Gruff::Export;
use VimPlugger::check;
#use VimPlugger::datas;

#use Git::Wrapper;

my @q = "select_groups" => "Repos of wich group do you want to select ?";

our sub repos_from_group($yaml) is export(:MANDATORY) {
  my @group_list = &choose_groups($yaml, ~q<select_groups>);
  my $err_flag = 0;
  my %failed;
  @group_list.map: { install_repos_from($yaml, $_, %failed) };
}

our sub all_repos($yaml) is export(:MANDATORY) {

}

our sub install_repos_from($yaml, Str $group_name) {
#  my $git = Git::Wrapper.new(gitdir => $!repo_dir);
#  my %group := $.datas.first: *<group> eq $group_name;
#  for %group<repos> -> %repo { my @answer = $git.run: 'clone', %repo<url>; } 
}

our sub install_repos($yaml, Str $group_name) {

}

our sub remove_repo_from($yaml, Str $group_name) {
  my %group := $yaml.datas.first: *<group> eq $group_name;
  my (@url, @dir);
  for %group<repos> -> %t { @url.push: %t<url> };
  @url.map: { 
    my @temp = $_.split: "/";
    @dir.push: "@temp[@temp.elems -1]";
    @dir.map: { $_ = $_ ~~ /\w+/; };
  };
  for @dir -> $path { 
    my $rep = $yaml.repo_dir ~~ "/" ~~ $path;
    run 'rm -Rf', "$rep";  }
}

our sub remove_repos($yaml) {
  for $yaml.datas -> %group { remove_repo_from($yaml, %group<group>); } 
}

our sub update_repos_from($yaml, Str $group_name) {

}

our sub update_repos($yaml) {

}

