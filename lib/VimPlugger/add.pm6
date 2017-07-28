#---add.pm----
unit module VimPlugger::add;
use Term::Choose;
use Prompt::Gruff::Export;
use VimPlugger::check; 
#use VimPlugger::datas;

########  PRIVATE FUNCTIONS  ##################################################################
my %q = 
  change_title   => "Change the title : ",
  change_url     => "Change the url   : ",
  give_title     => "Give me the new repo title: ",
  give_url       => "Give me the new repo url: ",
  add_new_repo   => "Would you like to add an other one new repo ? ",
  add_new_group  => "Do you want to add an other one group ? ",
  name_new_group => "Which name to give for this new group ? ",
  choose_group   => "which group for add repos inside ? choose...";


my sub ask_add_new {
  return prompt-for(~%q<add_new_repo>, :yn(True));
}

my sub ask_repo_datas {
  my ($title, $url);
  $title= prompt-for( ~%q<give_title> );
  $url= prompt-for( ~%q<give_url>, :regex('https:') );
  return ($title, $url);
}

my sub change_repo_datas(Str $title, Str $url) {
  $title = prompt-for( ~%q<change_title> );
  $url = prompt-for( ~%q<change_url>, :regex("https:") );
  return ($title, $url);
}

########  PUBLIC FUNCTIONS  #################################################################
# _Menu answer a) I want to add repos group
our sub group($yaml) is export(:MANDATORY) {
  my $group_name;
  while (1) {
    $group_name= prompt-for( ~%q<name_new_group>, :required(False) ); 
    return False if $group_name eq "";
    if ! check::group_exist($yaml, $group_name) {
      if ($group_name eq "") {
        say "exit... "; 
        return False;
      } else {
        $yaml.add_group( $group_name );
        $yaml.save();
        return True unless (prompt-for( ~%q<add_new_group>, :yn(True), :regex("[y|n]")));
      }
    } else { say "\ngroup exist allready... choose an other one name please."; }
  }
  return;
}

# _Menu answer b) i want to add repos
our sub repos($yaml) is export(:MANDATORY) {
  my ( @group_list, $group_index, $group_name );
  my $add_repo= 1;
  $yaml.datas.map: { @group_list.push: $_<group>; };
  $group_name = check::choose_group($yaml, ~q<choose_group>) until defined $group_name ;
  while ( $add_repo ) { 
    my $correct = 0 ;
    my ($title, $url) = ask_repo_datas();
    until ( $correct ) {
      my $answer = check::repo_is_correct( $yaml, $group_name, $title, $url );
      given "$answer" {
        when "title exist" { say "title exist allready in the database"; 
                             $title = (prompt-for ( ~%q<change_title>)); }
        when "url exist" { say "url exist allready in the database"; 
                           $url = prompt-for( ~%q<change_url>, :regex("https:") ); }
        when "want to change" { ( $title, $url ) = change_repo_datas( $title, $url );  }
        when "remote repo failed" { say "remote repo does not exist or is down"; 
                                    $url = prompt-for( ~%q<change_url>, :regex("https:") ); }
        when "all is ok" { 
          $yaml.add_repo( $group_name, $title, $url );
          $yaml.save(); 
          $correct = 1;
        }
      }
    }
    $add_repo = ask_add_new();
  }
  return;
}
