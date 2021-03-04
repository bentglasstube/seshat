package Seshat;

use Dancer2;
use Dancer2::Plugin::Database;
use DateTime;

hook before_template_render => sub {
  my $tokens = shift;

  $tokens->{mood_icons} = {
    1 => '&#x1f627;',
    2 => '&#x2639;',
    3 => '&#x1f610;',
    4 => '&#x1f600;',
    5 => '&#x1f603;',
  };
};

get '/' => sub {
  my @entries = database->quick_select('entry', {}, {
    order_by => { desc => 'logged_at' },
    limit => 10,
  });

  foreach my $entry (@entries) {
    $entry->{tags} = [database->quick_select('tag', {entry_id => $entry->{entry_id}})];
    $entry->{dt} = DateTime->from_epoch(
      epoch => $entry->{logged_at},
      time_zone => 'America/Los_Angeles',
    );
  }

  template 'log.tt', { entries => \@entries };
};

1;
