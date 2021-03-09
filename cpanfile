requires 'perl', '5.024';

requires 'Dancer2';
requires 'Dancer2::Plugin::Database';
requires 'DateTime';
requires 'DateTime::Format::ISO8601';
requires 'DBD::SQLite';
requires 'Template';
requires 'Template::Plugin::Markdown';
requires 'Text::Markdown';

# Text::Markdown needs this but doesn't seem to import it correctly
requires 'Module::Install';
