# --
# Copyright (C) 2022 mo-azfar, https://github.com/mo-azfar
#
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Acl::TicketChecklistACL;

use strict;
use warnings;

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
	return 1 if !$Param{Config}->{ACLName};
	return 1 if !@{$Param{Config}->{ChecklistEndState}};
	return 1 if !@{$Param{Config}->{NotPossibleTicketState}};
	
	my $TicketChecklistObject = $Kernel::OM->Get('Kernel::System::PerlServices::TicketChecklist');
    my $TicketChecklistStatusObject = $Kernel::OM->Get('Kernel::System::PerlServices::TicketChecklistStatus');

	#getting task list
    my @TASKLIST = $TicketChecklistObject->TicketChecklistTicketGet(
        TicketID => $Param{TicketID},
    );
	
	my $ACLGenerate = 0;
    ACL:
	
	foreach my $Task (@TASKLIST)
	{
		my %TicketChecklistStatusData = $TicketChecklistStatusObject->TicketChecklistStatusGet( ID => $Task->{StatusID} );
		
		if ( grep( /^$TicketChecklistStatusData{Name}$/ , @{$Param{Config}->{ChecklistEndState}} ) ) {
			#print "found it $TicketChecklistStatusData{Name}\n";
			$ACLGenerate = 0;
		}
		else
		{
			$ACLGenerate = 1;
			last ACL;
		}
			
	}

	if ($ACLGenerate)
	{
		$Param{Acl}->{$Param{Config}->{ACLName}} = {
        
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
                    State => [@{$Param{Config}->{NotPossibleTicketState}}],
                },
            },
        };
	}

    return 1;
}

1;
