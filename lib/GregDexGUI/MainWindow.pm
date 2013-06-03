package GregDex::GregDexGUI::MainWindow;
use Wx qw();
use Wx::Event qw( EVT_BUTTON );
use base Wx::Frame;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(
        undef,
        -1,
        "GregDex",
        [-1, -1],
        [-1, -1] );
    
    my $panel = Wx::Panel->new($self);
    
    # controls
    
    my $new_document_button = Wx::Button->new(
        $self,
        -1,
        "New...", # TODO: Implement as scalar to allow localization
        );
    EVT_BUTTON( $self,
                $new_document_button,
                \&NewDocumentDialog, );
    sub NewDocumentDialog {
        my $dummy_variable = Wx::MessageBox(
            "This function is not yet implemented!",
            "Not implemented!",
            Wx::wxOK,
            undef, );
    }
}