# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Acl::TicketChecklistACL;

use strict;
use warnings;
use Data::Dumper;

our @ObjectDependencies = (
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config Acl)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check if child tickets are not closed
    return 1 if !$Param{TicketID} || !$Param{UserID};
    
    my @NotPossibleTicketStates = split /;/, $Param{Config}->{NotPossibleTicketState};
    my $NotPossibleDynamicFieldName = $Param{Config}->{NotPossibleDynamicFieldName};
	my $NotPossibleDynamicFieldValue = $Param{Config}->{NotPossibleDynamicFieldValue};
    
    #For generating acl unique name
    my $random = int rand(8888);
    my $ACLName = 'ACLTC_'.$random.'_'.$Param{Config}->{Name};

    my $TicketChecklistObject = $Kernel::OM->Get('Kernel::System::PerlServices::TicketChecklist');
    my $TicketChecklistStatusObject = $Kernel::OM->Get('Kernel::System::PerlServices::TicketChecklistStatus');

    my @TASKLIST = $TicketChecklistObject->TicketChecklistTicketGet(
        TicketID => $Param{TicketID},
    );

    my $ACL = 0;
    
    if (@TASKLIST)
    {
        foreach my $Task (@TASKLIST)
        {
        my %TicketChecklistStatusData = $TicketChecklistStatusObject->TicketChecklistStatusGet( ID => $Task->{StatusID} );
        next if $TicketChecklistStatusData{Name} eq 'done';
        next if $TicketChecklistStatusData{Name} eq 'rejected';
        $ACL = 1;
        last;
        }
    }

    if ($ACL)
    {
        $Param{Acl}->{$ACLName} = {

            # match properties
            Properties => {

                # current ticket match properties
                Ticket => {
                    TicketID => [ $Param{TicketID} ],
                },
				
            },

            # return possible options (black list)
            PossibleNot => {

                # possible ticket options (black list)
                Ticket => {
                    'DynamicField_'.$NotPossibleDynamicFieldName => [$NotPossibleDynamicFieldValue],
                    State => [@NotPossibleTicketStates],
                },
            },
        };
        
    }
    
    return 1;
}

1;
