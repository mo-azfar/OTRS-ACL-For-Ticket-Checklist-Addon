# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Acl::TicketChecklistACL;

use strict;
use warnings;
use Data::Dumper;

our @ObjectDependencies = (
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

    return 1 if !$Param{TicketID} || !$Param{UserID};
    my @ChecklistEndState = split /;/, $Param{Config}->{ChecklistEndState};
    my @NotPossibleTicketStates = split /;/, $Param{Config}->{NotPossibleTicketState};
    my $NotPossibleDynamicFieldName = $Param{Config}->{NotPossibleDynamicFieldName};
	my @NotPossibleDynamicFieldValue = split /;/, $Param{Config}->{NotPossibleDynamicFieldValue};
    
    #For generating acl unique name
    my $random = int rand(8888);
    my $ACLName = 'ACLTC_'.$random.'_'.$Param{Config}->{Name};

    my $TicketChecklistObject = $Kernel::OM->Get('Kernel::System::PerlServices::TicketChecklist');
    my $TicketChecklistStatusObject = $Kernel::OM->Get('Kernel::System::PerlServices::TicketChecklistStatus');

    my @TASKLIST = $TicketChecklistObject->TicketChecklistTicketGet(
        TicketID => $Param{TicketID},
    );

    
    if (@TASKLIST)
    {
        my $count = 0;
        my @ChecklistCurrentState;
        
        foreach my $Task (@TASKLIST)
        {
        my %TicketChecklistStatusData = $TicketChecklistStatusObject->TicketChecklistStatusGet( ID => $Task->{StatusID} );
        push @ChecklistCurrentState,  $TicketChecklistStatusData{Name};
        $count ++;
        }
        
        my %original = ();
        my @isect = ();
        map { $original{$_} = 1 } @ChecklistEndState;
        @isect = grep { $original{$_} } @ChecklistCurrentState;
        
        #total number of matching checklist state not same as total checklist 
        if (scalar(@isect) ne $count)
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
                        'DynamicField_'.$NotPossibleDynamicFieldName => [@NotPossibleDynamicFieldValue],
                        State => [@NotPossibleTicketStates],
                    },
                },
            };
        
        }
        
        return 1;
    }

    return 1;
}

1;
