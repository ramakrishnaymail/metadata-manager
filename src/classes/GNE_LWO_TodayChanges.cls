global class GNE_LWO_TodayChanges implements Schedulable {


    public String orgURL = URL.getSalesforceBaseUrl().toExternalForm();

    global void execute(SchedulableContext SC) {
        GNE_LWO_TodayChanges emails = new GNE_LWO_TodayChanges ();
        emails.sendEmail();
    }

    public List<ApexPage> pages {
        get {
            if(pages == null) {
                pages = new List<ApexPage>();
            }
            return pages;
        }
        set;
    }
    
    public List<ApexClass> classes {
        get {
            if(classes == null) {
                classes = new List<ApexClass>();
            }
            return classes;
        }
        set;
    }    
    
    public List<ApexTrigger> triggers {
        get {
            if(triggers == null) {
                triggers = new List<ApexTrigger>();
            }
            return triggers;
        }
        set;
    }     

    Map<String, String> userIdNames {
        get {
            if(userIdNames == null) {
                userIdNames = new Map<String, String>();
            }
            return userIdNames;
        }
        set;
    }
    
    public String today {
        get {
            return System.today().format();
        }
        
        set;
    }
    
    public String[] toEmailAddresses;
    
    public GNE_LWO_TodayChanges() {
        //TODAY
        //YESTERDAY
        //THIS_WEEK
        //LAST_WEEK
        //THIS_MONTH
        //LAST_MONTH
        //LAST_90_DAYS
        //THIS_YEAR
        //LAST_YEAR
            
         pages = [SELECT Id, Name, ControllerType, ControllerKey,  CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexPage where LastModifiedDate = YESTERDAY order by LastModifiedDate Desc ];   
         classes = [SELECT Id, Name,  LengthWithoutComments, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexClass where LastModifiedDate = YESTERDAY order by LastModifiedDate Desc];
         triggers = [SELECT Id, Name, TableEnumOrId,  LengthWithoutComments, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexTrigger  where LastModifiedDate = YESTERDAY order by LastModifiedDate Desc];
         
         List<String> userIds = new List<String>();
         if(pages != null) {
             for(ApexPage page: pages) {
                userIds.add(page.LastModifiedById);
             }
         }
         
         if(classes != null) {
             for(ApexClass apexclass: classes ) {
                userIds.add(apexclass.LastModifiedById);
             }
         }         

         if(triggers != null) {
             for(ApexTrigger apextrigger: triggers ) {
                userIds.add(apextrigger.LastModifiedById);
             }
         }

         List<User> users = [SELECT Id, Name, Email from User where Id in :userIds];
         if(users != null) {
             toEmailAddresses = new String[users.size()];
             Integer i = 0;
             for(User user: users) {
                 userIdNames.put(user.Id, user.Name);
                 toEmailAddresses[i] = user.Email;
                 i++;
             }
         }             
    }
    
   
    public PageReference sendEmail() {
        //Send email
        try {
            //if(toEmailAddresses == null || toEmailAddresses.size() <= 0) {
            toEmailAddresses = new String[] {'boinepar@gene.com'};
            //}
            
            Boolean anythingChanged = false;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toEmailAddresses);
            //mail.setCcAddresses(toEmailAddresses);
            mail.setSenderDisplayName('LWO DEV Daily Status');
            mail.setSubject('LWO Metadata components changed by Developers on DEV Sandbox Yesterday' );
            String emailBody = '';
            
            emailBody += '<table width=\"850\" style=\"color:#000000;background-color:#e5eecc;padding-top:8px;padding-bottom:8px;padding-left:10px;padding-right:10px;border:1px solid #d4d4d4;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">';
            emailBody += '<tr><td>';
            emailBody += '<h2 class=\"example\">Visualforce Pages</h2>';
            emailBody += '<table style=\"background-color:#ffffff;border:1px solid #c3c3c3;border-collapse:collapse;\" cellspacing=\"0\" cellpadding=\"0\" border=\"1\" width=\"700\">';
            emailBody += '<tr>';            
            emailBody += '<th width=\"375\"">Name</th>';            
            emailBody += '<th>Last Modified By</th>';            
            emailBody += '<th>Last Modified Date</th>';
            emailBody += '<th>Size</th>';
            emailBody += '</tr>';                                    
            for(ApexPage page: pages) {
                if(page.Name.contains('LWO') || page.Name.startsWith('Product') || page.Name.startsWith('GNEProduct')) {
                     emailBody += '<tr>';
                     emailBody += '<td> <a href=\"' + orgURL + '/' + page.Id + '" target=\"_blank\">' + page.Name + '</a></td>';
                     emailBody += '<td>' + userIdNames.get(page.LastModifiedById)  + '</td>';
                     emailBody += '<td>' + page.LastModifiedDate  + '</td>';
                     emailBody += '<td>' + '-'  + '</td>';
                     emailBody += '</tr>';
                     
                     anythingChanged = true;
                }
             }
            
            emailBody += '</table>';
            emailBody += '</td></tr></table><br/><br/>';
            
            
            emailBody += '<table width=\"850\" style=\"color:#000000;background-color:#e5eecc;padding-top:8px;padding-bottom:8px;padding-left:10px;padding-right:10px;border:1px solid #d4d4d4;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">';
            emailBody += '<tr><td>';
            emailBody += '<h2 class=\"example\">Apex Classes</h2>';
            emailBody += '<table style=\"background-color:#ffffff;border:1px solid #c3c3c3;border-collapse:collapse;\" cellspacing=\"0\" cellpadding=\"0\" border=\"1\" width=\"700\">';
            emailBody += '<tr>';            
            emailBody += '<th width=\"375\"">Name</th>';            
            emailBody += '<th>Last Modified By</th>';            
            emailBody += '<th>Last Modified Date</th>';
            emailBody += '<th>Size</th>';
            emailBody += '</tr>';                                    
            
            for(ApexClass apexclass: classes) {
                if(apexclass.Name.contains('LWO') || apexclass.Name.startsWith('Product')|| apexclass.Name.startsWith('GNEProduct')) {
                     emailBody += '<tr>';
                     emailBody += '<td> <a href=\"' + orgURL + '/' + apexclass.Id + '" target=\"_blank\">' + apexclass.Name + '</a></td>';
                     emailBody += '<td>' + userIdNames.get(apexclass.LastModifiedById)  + '</td>';
                     emailBody += '<td>' + apexclass.LastModifiedDate  + '</td>';
                     emailBody += '<td>' + apexclass.LengthWithoutComments + '</td>';
                     emailBody += '</tr>';
                     
                     anythingChanged = true;
                }
             }
            
            emailBody += '</table>';
            emailBody += '</td></tr></table><br/><br/>';
            
            


            emailBody += '<table width=\"850\" style=\"color:#000000;background-color:#e5eecc;padding-top:8px;padding-bottom:8px;padding-left:10px;padding-right:10px;border:1px solid #d4d4d4;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">';
            emailBody += '<tr><td>';
            emailBody += '<h2 class=\"example\">Apex Triggers</h2>';
            emailBody += '<table style=\"background-color:#ffffff;border:1px solid #c3c3c3;border-collapse:collapse;\" cellspacing=\"0\" cellpadding=\"0\" border=\"1\" width=\"700\">';
            emailBody += '<tr>';            
            emailBody += '<th width=\"375\"">Name</th>';            
            emailBody += '<th>Last Modified By</th>';            
            emailBody += '<th>Last Modified Date</th>';
            emailBody += '<th>Size</th>';
            emailBody += '</tr>';                                    
            for(ApexTrigger apextrigger: triggers) {
                if(apextrigger.Name.contains('LWO') || apextrigger.Name.startsWith('Product')|| apextrigger.Name.startsWith('GNEProduct')) {
                  emailBody += '<tr>';
                  emailBody += '<td> <a href=\"' + orgURL + '/' + apextrigger.Id + '" target=\"_blank\">' + apextrigger.Name + '</a></td>';
                  emailBody += '<td>' + userIdNames.get(apextrigger.LastModifiedById)  + '</td>';
                  emailBody += '<td>' + apextrigger.LastModifiedDate  + '</td>';
                  emailBody += '<td>' + apextrigger.LengthWithoutComments  + '</td>';
                  emailBody += '</tr>';
                  
                  anythingChanged = true;
                }
            }
            
            emailBody += '</table>';
            emailBody += '</td></tr></table><br/><br/>';
            
            mail.setHtmlBody(emailBody);  
            if(anythingChanged) {  
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
            }           
        } catch(Exception ex) {
            System.debug('@@@Error Sending Email');
            System.debug(ex);
        }    
        return null;
    }
}