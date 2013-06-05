package GregDex::Indexer;

use Moose;
use namespace::autoclean;
use DBI;
use TryCatch;

=head1 NAME

GregDex::Indexer - document indexing backend for GregDex

=head1 SYNOPSIS

NOTE: Incomplete synopsis.

    use GregDex::Indexer;
    my $dbh
    $indexer = new GregDex::Indexer(
        db_type => 'sqlite',
        db_ref => \$dbh,
        db_path => '~/.GregDex/var/index.db',
    );
    
    $indexer->open_index();
    $indexer->initialize_index();
    $indexer->create_field("Document_Name", "varchar");
    
    my $document_path = "/home/someuser/Projects/GregDex/lib/Indexer.pm";
    my %document_metadata = (
        "Document_Name", "Grocery Receipt",
    );
    
    $indexer->add_document($document_path, %document_metadata);
    
    $indexer->create_field("Document_Author", "varchar");
    $indexer->create_field("Document_Date", "date");
    
    $document_metadata{"Document_Author"} = "Ryan Northrup";
    $document_metadata{"Document_Date"] = "2013-06-04";
    
    $indexer->update_document($document_path, %document_metadata);
    
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

Something to note: GregDex::Indexer does nothing to enforce how it's internally
structured; all it really does is provide a consistent interface to a DBI-
compatible relational database.  While it does have some defaults geared toward
GregDex specifically, it will happily erase its default fields (namely, "id"
and "document_path").  It doesn't provide a way to create customized tables,
however, so it's not a full wrapper to DBI, nor should it be.

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

=item new

    my $indexer = GregDex::Indexer->new(
        db_type => 'sqlite',
        db_ref => \$dbh,
        db_path => '~/.GregDex/var/index.db',
    );

The constructor.  See the ATTRIBUTES section above for information on which
parameters are available/expected/required/etc.

=item initialize_index

    $indexer->initialize_index();

Initializes a GregDex index using the parameters specified during object
construction.  This index is implemented as a new database with one table
(named using the db_table attribute) containing two columns - one for the
document IDs, and the other for paths to documents on the filesystem.

Returns true (1) if successful.

=cut

sub initialize_index {
    my $self = shift;
    my $index_db = $self->db_ref;
    $$index_db->do("CREATE TABLE $self->db_table (id INTEGER PRIMARY KEY, path TEXT)");
    return 1;
}

=item open_index

    $indexer->open_index();

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

=item close_index

    $indexer->close_index();

Closes a currently-open GregDex index.  Returns true (1) if successful.

=cut

sub close_index {
    my $self = shift;
    my $index_db = $self->db_ref;
    $$index_db->disconnect();
    return 1;
}

=item delete_index

    $indexer->delete_index();

This currently does nothing, since non-file-based databases haven't been
implemented.  To delete a SQLite-based index, just delete the .db file (at
least until the implementation of delete_index does that for you).

Will return true (1) if successful.

=cut

sub delete_index {
    # TODO: Implement delete_index
}

=item list_fields

    my %available_fields = $indexer->list_fields();

Returns a list of all available metadata fields and their data types as a hash.

=cut

sub list_fields {
    my $self = shift;
    my $index_db = $self->db_ref;
    # I have no idea if the following will work with SQLite; if it doesn't, I
    # will have to resort to an if/then block to handle both SQLite and
    # everything else.
    my $query = $$index_db->prepare("SELECT column_name, data_type FROM information_schema.columns WHERE table_name=\'$self->db_table\'");
    $query->execute();
    my (%results, $column_name, $data_type);
    while(($column_name, $data_type) = $query->fetchrow()) {
        $results{$column_name} = $data_type;
    }
    return %results;
}

=item create_field

    $indexer->create_field( "Document_Author", "varchar" );
    $indexer->create_field( "Document_Date", "date" );

Adds a new field to the index.  First parameter is the field name, which is
required; the second parameter - for the field's data type - is optional, and
defaults to "varchar" if omitted.  The data type should be a valid SQL data
type.

Returns true (1) if successful, or undefined if unsuccessful.

=cut

sub create_field {
    # TODO: Implement create_field
    my $self = shift;
    my $field_name = shift;
    if ( $field_name = undef ) {
        print "No field name specified!\n";
        return undef;
    }
    my $field_type = shift;
    if ( $field_type = undef ) { $field_type = "varchar" };
    # SQL stuff goes here
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
    my $self = shift;
    my $document_path = shift;
    my %document_metadata = shift;
    my $index_db = $self->db_ref;
    # SQL stuff goes here
}

sub search_for_document {
    # TODO: Implement search_for_document
}

sub retrieve_document {
    # TODO: Implement retrieve_document
}

sub update_document {
    # TODO: Implement update_document
    my $self = shift;
    my $document_path = shift;
    my $document_metadata = shift;
    # SQL stuff goes here
}

sub remove_document {
    # TODO: Implement remove_document
    my $self = shift;
    my $document_path = shift;
    # SQL stuff goes here
}

sub delete_document {
    # TODO: Implement delete_document
    my $self = shift;
    my $document_path = shift;
    
}

__PACKAGE__->meta->make_immutable;

1;