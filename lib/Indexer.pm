package GregDex::Indexer;

use Moose;
use namespace::autoclean;
use DBI;

=head1 NAME

GregDex::Indexer - document indexing backend for GregDex

=head1 SYNOPSIS

NOTE: Incomplete synopsis.

    use GregDex::Indexer;
    my $dbh
    $indexer = new GregDex::Indexer(
        db_type => 'sqlite',
        db_ref => \$indexer,
        db_path => '~/.GregDex/var/index.db',
    );
    
=head1 DESCRIPTION

GregDex::Indexer is designed to handle a good portion of the backend
functionality for GregDex, a Perl-based document indexing system for home and
individual users who don't need the full power of an enterprise-grade document
management system.  Namely, GregDex::Indexer takes a reference to a database
handle, automatically establishes a database connection using that handle, and
continues to utilize the provided handle/connection to store document metadata.

While GregDex::Indexer is not designed to be used outside of GregDex itself,
it has been designed to be as reusable as possible regardless, so as to be
useful to Perl hackers who want to interface with GregDex in their own scripts
and/or modules.

=head1 ATTRIBUTES

=item db_type

Right now, only 'sqlite' is supported.  This is, however, required.

=cut

has db_type (
    is => 'ro',
    required => 1,
);

=item db_ref

This should be a reference to a database handle.  A database connection does
not already need to be established; GregDex::Indexer handles this
automatically.  Like db_type, this is absolutely required.

=cut

has db_ref (
    is => 'ro',
    required => 1,
);

=item db_path

The path to a (SQLite) database file.  Should be provided if db_type is set to
'sqlite' (or any other file-based database type, if support for such databases
is eventually implemented).

=cut

has db_path (
    is => 'ro',
);

=item db_table

The name of the table used by the indexer.  This is optional; if not specified,
db_table is set to 'gregdex' by default.

=cut

has db_table (
    is => 'ro',
    default => 'gregdex',
);

=head1 METHODS

=item new()

The constructor.  See the ATTRIBUTES section above for information on which
parameters are available/expected/required/etc.

=item initialize_index()

Initializes a GregDex index using the parameters specified during object
construction.  This index is implemented as a new database with one table
(named using the db_table attribute) containing two columns - one for the
document IDs, and the other for paths to documents on the filesystem.

Returns true (1) if successful.

=cut

sub initialize_index {
    my $self = shift;
    my $index_db = $self->db_ref;
    $$index_db->do("CREATE TABLE $self->db_table (id INTEGER PRIMARY KEY, path TEXT);");
    return 1;
}

=item open_index()

Opens an existing GregDex index, or creates a new one if one doesn't already
exist, using the parameters specified during object construction.  Returns true
(1) if successful.

Note that if the database is newly created, you will need to run
initialize_index() before doing anything else with it (at least until I manage
to implement a check for an existing database).

=cut

sub open_index {
    my $self = shift;
    my $index_db = $self->db_ref;
    $$index_db = DBI->connect("dbi:SQLite:dbname=$self->db_file","","");
    return 1;
}

=item close_index()

Closes a currently-open GregDex index.  Returns true (1) if successful.

=cut

sub close_index {
    my $self = shift;
    my $index_db = $self->db_ref;
    $$index_db->disconnect();
    return 1;
}

=item delete_index()

This currently does nothing, since non-file-based databases haven't been
implemented.  To delete a SQLite-based index, just delete the .db file (at
least until the implementation of delete_index does that for you).

Will return true (1) if successful.

=cut

sub delete_index {
    # TODO: Implement delete_index
}

=item list_fields()

Returns a list of all available metadata fields and their data types as a hash.

=cut

sub list_fields {
    # TODO: Implement list_fields
}

sub create_field {
    # TODO: Implement create_field
}

sub edit_field_name {
    # TODO: Implement edit_field_name
}

sub edit_field_type {
    # TODO: Implement edit_field_type
}

sub delete_field {
    # TODO: Implement delete_field
}

sub add_document {
    # TODO: Implement add_document
}

sub search_for_document {
    # TODO: Implement search_for_document
}

sub retrieve_document {
    # TODO: Implement retrieve_document
}

sub update_document {
    # TODO: Implement update_document
}

sub remove_document {
    # TODO: Implement remove_document
}

sub delete_document {
    # TODO: Implement delete_document
}

__PACKAGE__->meta->make_immutable;

1;