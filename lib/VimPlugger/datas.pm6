#--datas.pm---

unit class VimPlugger::datas;
use YAMLish;

has Str $.filename is rw;
has Array $.datas;
has Str $!directory= %*ENV<HOME> ~ "/.vim/installer";
has Str $.repo_dir= %*ENV<HOME> ~ "/.vim/bundle";
has Str $!full_filename= $!directory ~ "/$!filename";
method new (Str $filename) {
  return self.bless: filename => $filename;
}

method TWEAK {
  self!initialize_directory();
  self!initialize_filename_data();
}

method !initialize_directory() {
  unless $!directory.IO.d  { mkdir $!directory or die "unable to create directory"; }
}

method !initialize_filename_data() {
  unless ($!full_filename.IO.f)  { 
    my $default = $[ ${ group => "default", repos => [ ] } ];
    spurt $!full_filename, save-yaml( $default );
  }
  $!datas = load-yaml(slurp $!full_filename);
}

method save {
  spurt $!full_filename, save-yaml($!datas) or die "can not save datas.yml";
  say "Datas has been saved.";
}

method add_group( Str $group_name ){  # problem, add group put url in title !!!
  $!datas.push: ${ group => "$group_name", repos => [] };
}

method add_repo(Str $group_name, Str $title, Str $url) {
  $!datas.map: {
    $_<repos>.push: { title => "$title", url => "$url"} if $_<group> eq $group_name;
    }
}
