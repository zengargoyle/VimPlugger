#---check.pm---
unit module VimPlugger::check;
use Prompt::Gruff::Export;
use Term::Choose;
#use VimPlugger::datas;

# check if group exist allready
our sub group_exist($yaml, $group) is export(:MANDATORY) {
  return defined $yaml.datas.first: *<group> eq $group;
}

our sub object_repo_exist($yaml, Str $object, 
                                 Str $object_name, 
                                 Str $group_name) is export { # object=title|url 
  my %group := $_ with $yaml.datas.first: *<group> eq $group_name;
  return defined %group<repos>.first: *.{$object} eq $object_name;
}

our sub git_repo_exist(Str $url) is export(:MANDATORY) {
  my ( $stderr, $stdout );
  
  #my @cmd = (qw/ git ls-remote/, $url);
  my $answer = run 'git', 'ls-remote', "$url", :out;
  for $answer.out.lines -> $lines {
    say $lines; }
  return True if $answer;
  return False;
}

our sub repo_is_correct($yaml, Str $group_name, 
                               Str $title, 
                               Str $url) is export(:MANDATORY) {
  return "title exist" if object_repo_exist( $yaml, "title", $title, $group_name );
  return "url exist" if object_repo_exist( $yaml, "url", $url, $group_name );
  return "remote repo failed" unless git_repo_exist ( $url );
  return "want to change" unless prompt-for( 
         "title: $title\nurl: $url\ncorrect ? Do we save this ?", :yn(True) ); 
  return "all is ok";
}

our sub repos_of_group_exist($yaml, Str $group, 
                                    Array @repos_list) is export(:MANDATORY) {
  my @repos_url_failed;
  my %repos_grouped := $_ with $yaml.datas.first: *<group> eq $group;
  for %repos_grouped<repos> -> %repo {
    @repos_url_failed.push(%repo<url>) if git_repo_exist(%repo<url>) ;
  }
  return @repos_url_failed;
}

our sub choose_groups($yaml, Str $speech) is export(:MANDATORY) {
  my (@group_list, @group_names, @group_indexs);
  $yaml.datas.map: { @group_list.push: $_<group>; };
  @group_indexs = choose-multi( @group_list, :prompt("$speech"),
                                :index(1), :mouse(1), :layout(2) );
  @group_indexs.map: { @group_names.push: @group_list[$_] };
  return @group_names;
}

our sub choose_group($yaml, Str $speech) is export(:MANDATORY) {
  my (@group_list, $group_name, $group_index);
  $yaml.datas.map: { @group_list.push: $_<group>; };
  $group_index = choose( @group_list, :prompt("$speech"),
                         :index(1), :mouse(1), :layout(2) );
  $group_name = @group_list[$group_index];
  return $group_name;
}
