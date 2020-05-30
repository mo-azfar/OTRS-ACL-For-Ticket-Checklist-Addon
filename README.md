# OTRS-ACL-For-Ticket-Checklist-Addon  
- Built for OTRS CE v6.0  
- This module extend Ticket Checklist addon by generating specific ACL (disable close state if checklist not complete)  
- Addon : https://github.com/reneeb/otrs-TicketChecklist  

1. This system ACL will disable the close state and some dynamic field value if checklist state for not 'done' or 'rejected'  

2. Enable or Update setting value at Admin > System Configuration > Ticket::Acl::Module###27-Ticket::Acl::Module   

        <Item Key="NotPossibleDynamicFieldName">Status</Item>  
				<Item Key="NotPossibleDynamicFieldValue">Pending Approval</Item>  
				<Item Key="NotPossibleTicketState">closed successful;closed unsuccessful</Item>  
        
3. This indicates to perform this ACL when checklist is not complete (not done / not rejected)   

    a) hide dynamic field name Status value (Pending Aproval)  
    b) hide ticket states closed successful and closed unsuccessful  
    
 
Checklist state not fully 'done' or 'rejected'  
[![download.png](https://i.postimg.cc/m2L3zqMr/download.png)](https://postimg.cc/5jrQDssc)  


Close state not available  
[![download-1.png](https://i.postimg.cc/JnCZ1dMM/download-1.png)](https://postimg.cc/jWvLccDF)  


Checklist state all done  
[![download-2.png](https://i.postimg.cc/7Y56WnrV/download-2.png)](https://postimg.cc/gnPmwRJX)  


Close states available back  
[![download-3.png](https://i.postimg.cc/ZRYYFrL6/download-3.png)](https://postimg.cc/67SNB4gQ)  
