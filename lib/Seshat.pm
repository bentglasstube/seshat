package Seshat;

use Dancer2;
use Dancer2::Plugin::Database;
use DateTime;
use DateTime::Format::ISO8601;

hook before_template_render => sub {
  my $tokens = shift;

  $tokens->{mood_icons} = {
    1 => '&#x1f622;',
    2 => '&#x1f641;',
    3 => '&#x1f610;',
    4 => '&#x1f642;',
    5 => '&#x1f601;',
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

post '/' => sub {
  my $time;

  if (my $ts = body_parameters->{ts}) {
    $time = DateTime::Format::ISO8601->parse_datetime($ts);
    $time->set_time_zone('America/Los_Angeles');
  } else {
    $time = DateTime->now();
  }

  database->quick_insert('entry', {
    logged_at => $time->epoch,
    entry => body_parameters->{entry}
  });

  if (my $mood = body_parameters->{mood}) {
    my $entry_id = database->last_insert_id();

    database->quick_insert('tag', {
      entry_id => $entry_id,
      tag => 'mood',
      value => $mood,
    });
  }


  redirect '/';
};

1;
