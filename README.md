# OTRS-Znuny-ACL-For-Ticket-Checklist-Addon  
- Built for OTRS CE v6.0 / Znuny Features 
- This module extend Ticket Checklist addon by generating specific ACL (e.g: disable close state if checklist not complete)  
- Addon : https://github.com/reneeb/otrs-TicketChecklist  / https://opar.perl-services.de/dist/TicketChecklist    

1. This system ACL will disable the close state if checklist state not 'done' or 'rejected' (as configured) 

2. Enable and update setting value (if needed) at Admin > System Configuration > Ticket::Acl::Module###27-TicketChecklistACL

		ChecklistEndState 
			- done
			- rejected
			
		NotPossibleTicketState
			- closed successful
			- closed unsuccessful


		ChecklistEndState = Possible ending / complete for checklist state. Accept multiple value.
		NotPossibleTicketState = Ticket state that will be hide upon checklist end state not fully complete. Accept multiple value. 
				
 
Checklist state not fully 'done' or 'rejected'  
[![download.png](https://i.postimg.cc/m2L3zqMr/download.png)](https://postimg.cc/5jrQDssc)  


Close state not available  
[![download-1.png](https://i.postimg.cc/JnCZ1dMM/download-1.png)](https://postimg.cc/jWvLccDF)  


Checklist state all done  
[![download-2.png](https://i.postimg.cc/7Y56WnrV/download-2.png)](https://postimg.cc/gnPmwRJX)  


Close states available back  
[![download-3.png](https://i.postimg.cc/ZRYYFrL6/download-3.png)](https://postimg.cc/67SNB4gQ)  
