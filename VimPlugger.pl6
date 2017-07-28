#!/usr/bin/perl6
#
use Term::Choose;
use VimPlugger::datas;
use VimPlugger::install;
use VimPlugger::add;

my $mode;
my $yaml = VimPlugger::datas.new("my_pl6.yml");
my %menu = ( Initial   => < List Add Modify Remove Install Uninstall Update Quit >,
             List      => ( "Liste repos of group", "Liste all the repos of database", 
                            "List all installed repos" ),
             Add       => ( "Add new group", "Add new repos to group" ),
             Remove    => ( "Remove group", "Remove repos from group" ),
             Modify    => ( "Modify name of group", "Mofify repos" ),
             Install   => ( "Install repos from group", "Install all repos" ),
             Uninstall => ( "Unisnstall repos from group", "Uninstall all repos" ) );

# Questions: what to do ?
sub menu($title, @list) {
   my $title_ex = "\nWhat do you want to do ?\n $title";
    $mode = choose( @list, :index(0), :layout(2), :mouse(1), :prompt($title_ex) );
  return $mode;
}

while ( $mode = menu("Choose:", %menu<Initial>) ) {
  given $mode {
    when "List" { 
      my $action = menu("Print a list: ", %menu<List>);
      given $action {
        when "List all the repos of database" {  }
        when "List repos of group" {  }
        when "List all installed repos" {  } } }
    when "Add" {
      my $action = menu("Add something: ", %menu<Add>);
      given $action {
        when "Add new group" { add::group($yaml); } 
        when "Add new repos to group" { add::repos($yaml); } } }
    when "Modify" {
      my $action = menu("Modification :", %menu<Modify>);
      given $action {
        when "Modify a repos" {  }
        when "Modify name of group" {  } } }
    when "Remove" {
      my $action = menu("Remove:", %menu<Remove>);
      given $action {
        when "Remove repos from a group" {  }
        when "Remove group" {  } } }
    when "Install" {
      my $action = menu("Install for vim", %menu<Install>);
      given $action {
        when "Install repos from group" { install::repos_from_group($yaml); }
        when "Install all repos" { install::all_repos($yaml) } } }
    when "Uninstall" {
      my $action = menu("Uninstall repos:", %menu<Uninstall>);
      given $action {
        when "Uninstall repos from group" {  }
        when "Uninstall all repos" {  } } }
    when "Update" {  } 
    when "Quit" { exit; }
  }
}
