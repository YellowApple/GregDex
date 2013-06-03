package GregDex::Indexer;

use Moose;
use namespace::autoclean;
use DBI;

# Attributes

# Database attributes
has db_type (
    is => 'rw',
    default => 'sqlite',
);

has db_name (
    is => 'rw',
    default => 'gregdex',
);

has db_table (
    is => 'rw',
    default => 'gregdex',
);

has [   'db_file',
        'db_host',
        'db_port',
        'db_user',
        'db_pass',
        'db_handle',
] => (
        is => 'rw',
);

# Methods

sub create_index { # TODO: make create_index code less redundant
    my $self = shift;
    my $db_type = $self->db_type;
    if $db_type = 'mysql' {
        # TODO: Implement MySQL support
    } else { # default to SQLite
        my $db_file = $self->db_file;
        my $db_handle = DBI->connect("dbi:SQLite:dbname=$db_file","","");
        my $db_table = $self->db_table;
        $db_handle->do("CREATE TABLE $db_table (id INTEGER PRIMARY KEY, path TEXT)");
        $self->db_handle($db_handle);
    }
    return 1;
}

sub open_index {
    my $self = shift;
    my $db_type = $self->db_type;
    if $db_type = 'mysql' {
        # TODO: Implement MySQL support
    } else { # default to SQLite
        my $db_file = $self->db_file;
        my $db_handle = DBI->connect("dbi:SQLite:dbname=$db_file","","");
        $self->db_handle($db_handle);
    }
    return 1;
}

sub close_index {

}

sub delete_index {

}

sub list_fields {

}

sub create_field {

}

sub delete_field {

}

sub add_document {

}

sub retrieve_document {

}

sub update_document {

}

sub remove_document {

}

__PACKAGE__->meta->make_immutable;

1;