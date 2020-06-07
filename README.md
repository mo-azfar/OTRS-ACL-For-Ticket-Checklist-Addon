# OTRS-ACL-For-Ticket-Checklist-Addon  
- Built for OTRS CE v6.0  
- This module extend Ticket Checklist addon by generating specific ACL (e.g: disable close state if checklist not complete)  
- Addon : https://github.com/reneeb/otrs-TicketChecklist  

1. This system ACL will disable the close state and some dynamic field value if checklist state not 'done' or 'rejected' (as configured) 

2. Enable and update setting value at Admin > System Configuration > Ticket::Acl::Module###27-Ticket::Acl::Module   

        		<Item Key="ChecklistEndState">done;rejected</Item>
				<Item Key="NotPossibleDynamicFieldName">Status</Item>  
				<Item Key="NotPossibleDynamicFieldValue">Pending Approval</Item>  
				<Item Key="NotPossibleTicketState">closed successful;closed unsuccessful</Item>  


		ChecklistEndState = Possible ending / complete for checklist state. Accept multiple value separate by semicolon ;  
		NotPossibleDynamicFieldName = Dynamic field 'name' that the value will be hide upon checklist end state not fully complete. Accept single value only  
		NotPossibleDynamicFieldValue = Dynamic field 'value' that will be hide upon checklist end state not fully complete. Accept multiple value separate by semicolon ;  
		NotPossibleTicketState = Ticket state that will be hide upon checklist end state not fully complete. Accept multiple value separate by semicolon ;  
				
 
Checklist state not fully 'done' or 'rejected'  
[![download.png](https://i.postimg.cc/m2L3zqMr/download.png)](https://postimg.cc/5jrQDssc)  


Close state not available  
[![download-1.png](https://i.postimg.cc/JnCZ1dMM/download-1.png)](https://postimg.cc/jWvLccDF)  


Checklist state all done  
[![download-2.png](https://i.postimg.cc/7Y56WnrV/download-2.png)](https://postimg.cc/gnPmwRJX)  


Close states available back  
[![download-3.png](https://i.postimg.cc/ZRYYFrL6/download-3.png)](https://postimg.cc/67SNB4gQ)  
