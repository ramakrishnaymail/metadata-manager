global class GNE_CM_MPS_DailyStatusEmails implements Schedulable {

    public Map<String, List<ApexPage>> pagesPerDeveloper {
        get {
            if(pagesPerDeveloper == null) {
                pagesPerDeveloper = new Map<String, List<ApexPage>>();
            }
            return pagesPerDeveloper;
        }
        set;
    }
    
    public Map<String, List<ApexClass>> classesPerDeveloper {
        get {
            if(classesPerDeveloper == null) {
                classesPerDeveloper = new Map<String, List<ApexClass>>();
            }
            return classesPerDeveloper;
        }
        set;
    }    
    
    public Map<String, List<ApexTrigger>> triggersPerDeveloper {
        get {
            if(triggersPerDeveloper == null) {
                triggersPerDeveloper = new Map<String, List<ApexTrigger>>();
            }
            return triggersPerDeveloper;
        }
        set;
    }     

    public Map<String, List<StaticResource>> staticResourcesPerDeveloper {
        get {
            if(staticResourcesPerDeveloper == null) {
                staticResourcesPerDeveloper = new Map<String, List<StaticResource>>();
            }
            return staticResourcesPerDeveloper;
        }
        set;
    }     

    public Map<String, String> pagesPerDeveloperEmail {
        get {
            if(pagesPerDeveloperEmail == null) {
                pagesPerDeveloperEmail = new Map<String, String>();
            }
            return pagesPerDeveloperEmail;
        }
        set;
    }
    
    public Map<String, String> classesPerDeveloperEmail {
        get {
            if(classesPerDeveloperEmail == null) {
                classesPerDeveloperEmail = new Map<String, String>();
            }
            return classesPerDeveloperEmail;
        }
        set;
    }    
    
    public Map<String, String> triggersPerDeveloperEmail {
        get {
            if(triggersPerDeveloperEmail == null) {
                triggersPerDeveloperEmail = new Map<String, String>();
            }
            return triggersPerDeveloperEmail;
        }
        set;
    }     

    public Map<String, String> staticResourcesPerDeveloperEmail {
        get {
            if(staticResourcesPerDeveloperEmail == null) {
                staticResourcesPerDeveloperEmail = new Map<String, String>();
            }
            return staticResourcesPerDeveloperEmail;
        }
        set;
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

    public List<StaticResource> staticResources {
        get {
            if(staticResources == null) {
                staticResources = new List<StaticResource>();
            }
            return staticResources;
        }
        set;
    }


    public Map<String, String> conflictPages {
        get {
            if(conflictPages == null) {
                conflictPages = new Map<String, String>();
            }
            return conflictPages;
        }
        set;
    }
    
    public Map<String, String> conflictClasses {
        get {
            if(conflictClasses == null) {
                conflictClasses = new Map<String, String>();
            }
            return conflictClasses;
        }
        set;
    }    
    
    public Map<String, String> conflictTriggers {
        get {
            if(conflictTriggers == null) {
                conflictTriggers = new Map<String, String>();
            }
            return conflictTriggers;
        }
        set;
    }     

    public Map<String, String> conflictStaticResources {
        get {
            if(conflictStaticResources == null) {
                conflictStaticResources = new Map<String, String>();
            }
            return conflictStaticResources;
        }
        set;
    }

    public List<User> users {
        get {
            if(users == null) {
                users = new List<User>();
            }
            return users;
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
    
    public String[] ccEmailAddresses;
    
    public String orgURL = URL.getSalesforceBaseUrl().toExternalForm();
        
	  public List<Code_Conflict__c> codeConflicts {
	    get {
	      if(codeConflicts == null) {
	       codeConflicts = new List<Code_Conflict__c>();
	      }
	      
	      return codeConflicts;
	    }
	    set;
	  }
        
    public GNE_CM_MPS_DailyStatusEmails() {
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
         staticResources = [SELECT BodyLength,CacheControl,ContentType,Id,LastModifiedById,LastModifiedDate,Name FROM StaticResource where LastModifiedDate = YESTERDAY order by LastModifiedDate Desc];
         
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

         if(staticResources != null) {
             for(StaticResource staticResource: staticResources) {
                userIds.add(staticResource.LastModifiedById);
             }
         }

         users = [SELECT Id, Name, Email from User where Id in :userIds];
         if(users != null) {
             ccEmailAddresses = new String[users.size()];
             Integer i = 0;
             for(User user: users) {
                 userIdNames.put(user.Id, user.Name);
                 ccEmailAddresses [i] = user.Email;
                 i++;
             }
         }         
         
         codeConflicts = [SELECT Id, Name, Track__c, Code_Name__c,Code_Type__c,Conflicted_By_Email__c,Conflicted_By__c,Locked_By_Email__c,
                            Locked_By__c,Locked__c FROM Code_Conflict__c where Locked__c = true];
                            
         for(Code_Conflict__c codeConflict : codeConflicts) {
         	if(codeConflict.Code_Type__c == 'Page') {
         		if(containsInPages(codeConflict.Code_Name__c)) {
         			conflictPages.put(codeConflict.Code_Name__c, codeConflict.Locked_By_Email__c );
         		}
         	} else if(codeConflict.Code_Type__c == 'Class') {
         		if(containsInClasses(codeConflict.Code_Name__c)) {
         			conflictClasses.put(codeConflict.Code_Name__c,codeConflict.Locked_By_Email__c);
         		}
         	} else if(codeConflict.Code_Type__c == 'Trigger') {
         		if(containsInTriggers(codeConflict.Code_Name__c)) {
         			conflictTriggers.put(codeConflict.Code_Name__c, codeConflict.Locked_By_Email__c);
         		}
         	} else if(codeConflict.Code_Type__c == 'Static Resource') {
         		if(containsInStaticResources(codeConflict.Code_Name__c)) {
         			conflictStaticResources.put(codeConflict.Code_Name__c, codeConflict.Locked_By_Email__c);
         		}
         	} 
         }               
    }
    
    public Boolean containsInPages(String pageName) {
    	if(pages != null) {
	         for(ApexPage page: pages) {
	            if(page.Name == pageName) {
	            	return true;
	            }
	         }
	     }
    	
    	return false;
    }

    public Boolean containsInClasses(String className) {
    	if(classes != null) {
	         for(ApexClass clas: classes) {
	            if(clas.Name == className) {
	            	return true;
	            }
	         }
	     }
    	
    	return false;
    }

    public Boolean containsInTriggers(String triggerName) {
    	if(pages != null) {
	         for(ApexTrigger triggr: triggers) {
	            if(triggr.Name == triggerName) {
	            	return true;
	            }
	         }
	     }
    	
    	return false;
    }

    public Boolean containsInStaticResources(String staticName) {
    	if(pages != null) {
	         for(StaticResource sResource: staticResources) {
	            if(sResource.Name == staticName) {
	            	return true;
	            }
	         }
	     }
    	
    	return false;
    }
    
    global void execute(SchedulableContext SC) {
        GNE_CM_MPS_DailyStatusEmails emails = new GNE_CM_MPS_DailyStatusEmails();
        emails.sendEmail();
        emails.sendConflictEmails();
    }
    
    public PageReference sendConflictEmails() {

            for(User user: users) {
                String userId = user.Id;
                String userName = user.Name;
                String userEmail = user.Email;
                
                for(ApexPage page: pages) {
                    if(userId == page.LastModifiedById) {
		                pagesPerDeveloperEmail.put(page.Name, userEmail);
                    }
                }
                
                for(ApexClass apexclass: classes) {
                    if(userId == apexclass.LastModifiedById) {
                        classesPerDeveloperEmail.put(apexclass.Name, userEmail);
                    }
                }
                
                for(ApexTrigger apextrigger: triggers) {
                    if(userId == apextrigger.LastModifiedById) {
                        triggersPerDeveloperEmail.put(apextrigger.Name, userEmail);
                    }
                }

                for(StaticResource sResource: staticResources) {
                    if(userId == sResource.LastModifiedById) {
                        staticResourcesPerDeveloperEmail.put(sResource.Name, userEmail);
                    }
                }
            }
    	
	     if(conflictPages != null) {
	     	System.debug('conflictPages size: ' + conflictPages.size());
	         for(String page: conflictPages.keySet()) {
	            String lockedByEmail = conflictPages.get(page);
	            String modifiedByEmail = pagesPerDeveloperEmail.get(page);
	            
	            System.debug('page: ' + page);
	            System.debug('lockedByEmail: ' + lockedByEmail);
	            System.debug('modifiedByEmail: ' + modifiedByEmail);

	            if(lockedByEmail != null && modifiedByEmail != null && !lockedByEmail.contains(modifiedByEmail)) {
	            	
	            	//Send email
		            String[] ccEmailAddresses = new String[] {'ramak1@gene.com', 'vinodk@gene.com'};
		            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		            mail.setToAddresses(parseEmails(lockedByEmail, modifiedByEmail));
		            mail.setCcAddresses(ccEmailAddresses);
		            
		            mail.setSenderDisplayName('DEV Code Conflict');
		            mail.setSubject('Code conflict detected in DEV sandbox Yesterday' );
		            String emailBody = '<b>Code conflict found:</b><br/>';
		            emailBody += 'Code Type: Page<br/>';
		            emailBody += 'Code Name: ' + page + '<br/>';
		            emailBody += 'Locked By: ' + lockedByEmail + '<br/>';
		            emailBody += 'Conflicted By: ' + modifiedByEmail + '<br/><br/>';
		            emailBody += 'Please work together to resolve the conflict.';

		            mail.setHtmlBody(emailBody);    
		            
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                   
	            }
	         }
	     }
    	

	     if(conflictClasses != null) {
	     	System.debug('conflictClasses size: ' + conflictClasses.size());
	         for(String clas: conflictClasses.keySet()) {
	            String lockedByEmail = conflictClasses.get(clas);
	            String modifiedByEmail = classesPerDeveloperEmail.get(clas);
	            
	            System.debug('clas: ' + clas);
	            System.debug('lockedByEmail: ' + lockedByEmail);
	            System.debug('modifiedByEmail: ' + modifiedByEmail);
	            
	            if(lockedByEmail != null && modifiedByEmail != null && !lockedByEmail.contains(modifiedByEmail)) {
	            	//Send email
		            String[] ccEmailAddresses = new String[] {'ramak1@gene.com', 'vinodk@gene.com'};
		            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		            mail.setToAddresses(parseEmails(lockedByEmail, modifiedByEmail));
		            mail.setCcAddresses(ccEmailAddresses);
		            
		            
		            mail.setSenderDisplayName('DEV Code Conflict');
		            mail.setSubject('Code conflict detected in DEV sandbox Yesterday' );
		            String emailBody = '<b>Code conflict found:</b><br/>';
		            emailBody += 'Code Type: Class<br/>';
		            emailBody += 'Code Name: ' + clas + '<br/>';
		            emailBody += 'Locked By: ' + lockedByEmail + '<br/>';
		            emailBody += 'Conflicted By: ' + modifiedByEmail + '<br/><br/>';
		            emailBody += 'Please work together to resolve the conflict.';

		            mail.setHtmlBody(emailBody);    
		            
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                   
	            }
	         }
	     }

	     if(conflictTriggers != null) {
	     	System.debug('conflictTriggers size: ' + conflictTriggers.size());
	         for(String triggr: conflictTriggers.keySet()) {
	            String lockedByEmail = conflictTriggers.get(triggr);
	            String modifiedByEmail = triggersPerDeveloperEmail.get(triggr);
	            
	            System.debug('triggr: ' + triggr);
	            System.debug('lockedByEmail: ' + lockedByEmail);
	            System.debug('modifiedByEmail: ' + modifiedByEmail);

	            if(lockedByEmail != null && modifiedByEmail != null && !lockedByEmail.contains(modifiedByEmail)) {
	            	//Send email
		            String[] ccEmailAddresses = new String[] {'ramak1@gene.com', 'vinodk@gene.com'};
		            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		            mail.setToAddresses(parseEmails(lockedByEmail, modifiedByEmail));
		            mail.setCcAddresses(ccEmailAddresses);
		            
		            
		            mail.setSenderDisplayName('DEV Code Conflict');
		            mail.setSubject('Code conflict detected in DEV sandbox Yesterday' );
		            String emailBody = '<b>Code conflict found:</b><br/>';
		            emailBody += 'Code Type: Trigger<br/>';
		            emailBody += 'Code Name: ' + triggr + '<br/>';
		            emailBody += 'Locked By: ' + lockedByEmail + '<br/>';
		            emailBody += 'Conflicted By: ' + modifiedByEmail + '<br/><br/>';
		            emailBody += 'Please work together to resolve the conflict.';

		            mail.setHtmlBody(emailBody);    
		            
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                   
	            }
	         }
	     }


	     if(conflictStaticResources != null) {
	     	System.debug('conflictStaticResources size: ' + conflictStaticResources.size());
	         for(String sResource: conflictStaticResources.keySet()) {
	            String lockedByEmail = conflictStaticResources.get(sResource);
	            String modifiedByEmail = staticResourcesPerDeveloperEmail.get(sResource);
	            
	            System.debug('sResource: ' + sResource);
	            System.debug('lockedByEmail: ' + lockedByEmail);
	            System.debug('modifiedByEmail: ' + modifiedByEmail);

	            if(lockedByEmail != null && modifiedByEmail != null && !lockedByEmail.contains(modifiedByEmail)) {
	            	//Send email
		            String[] ccEmailAddresses = new String[] {'ramak1@gene.com', 'vinodk@gene.com'};
		            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		            mail.setToAddresses(parseEmails(lockedByEmail, modifiedByEmail));
		            mail.setCcAddresses(ccEmailAddresses);
		            
		            
		            mail.setSenderDisplayName('DEV Code Conflict');
		            mail.setSubject('Code conflict detected in DEV sandbox Yesterday' );
		            String emailBody = '<b>Code conflict found:</b><br/>';
		            emailBody += 'Code Type: Static Resource<br/>';
		            emailBody += 'Code Name: ' + sResource + '<br/>';
		            emailBody += 'Locked By: ' + lockedByEmail + '<br/>';
		            emailBody += 'Conflicted By: ' + modifiedByEmail + '<br/><br/>';
		            emailBody += 'Please work together to resolve the conflict.';

		            mail.setHtmlBody(emailBody);    
		            
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                   
	            }
	         }
	     }

    	
    	return null;
    }
    
    public String[] parseEmails(String lockedByEmail, String modifiedByEmail) {
    	List<String> emails = new List<String>();
    	if(modifiedByEmail != null) {
    		emails.add(modifiedByEmail);
    	}
    	
    	if(lockedByEmail != null) {
    		List<String> lockedEmails = lockedByEmail.split(';');
    		for(String lockedEmail : lockedEmails) {
    			emails.add(lockedEmail);
    		}
    	}
    	
    	String[] allEmails = new String[emails.size()];
    	for(Integer i = 0; i < emails.size(); i++) {
    			allEmails[i] = emails.get(i);
    	}
    	return allEmails;
    }
    
    public PageReference sendEmail() {
        //Send email
        try {
            String[] toAddresses = new String[] {'ramak1@gene.com', 'wilczekk@gene.com', 'singhh6@gene.com', 'kishorec@gene.com', 'nadinel@gene.com', 'vinodk@gene.com'};
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            
            if(ccEmailAddresses != null && ccEmailAddresses.size() > 0) {
                mail.setCcAddresses(ccEmailAddresses);
            }
            
            mail.setSenderDisplayName('DEV Daily Status');
            mail.setSubject('Metadata components changed by Developers on DEV Yesterday' );
            String emailBody = '';
            
            emailBody += '<b>Please update the Google Doc Code Conflicts with your updated changes.</b><br/>';
            emailBody += '<a href=\"https://docs.google.com/a/gene.com/spreadsheet/ccc?key=0AlRb0T2b3D4edGdfM0FfdVRJenZkN281dFVIRW5fWUE&pli=1#gid=2\"> Link to CMR4 - MPSR3 SFDC - Code Conflicts </a><br/><br/>';            
            emailBody += '<b> Also make sure you check-in your code to Subversion with Jira Task Number.</b><br/><br/>';
            
            
            for(User user: users) {
                String userId = user.Id;
                String userName = user.Name;
                String userEmail = user.Email;
                List<ApexPage> pagesForUser = new List<ApexPage>();
                List<ApexClass> classesForUser = new List<ApexClass>();
                List<ApexTrigger> triggersForUser = new List<ApexTrigger>();
                List<StaticResource> staticResourcesForUser = new List<StaticResource>();
                
                for(ApexPage page: pages) {
                    if(userId == page.LastModifiedById) {
                        pagesForUser.add(page);
                    }
                }
                
                for(ApexClass apexclass: classes) {
                    if(userId == apexclass.LastModifiedById) {
                        classesForUser.add(apexclass);
                    }
                }
                
                for(ApexTrigger apextrigger: triggers) {
                    if(userId == apextrigger.LastModifiedById) {
                        triggersForUser.add(apextrigger);
                    }
                }

                for(StaticResource sResource: staticResources) {
                    if(userId == sResource.LastModifiedById) {
                        staticResourcesForUser.add(sResource);
                    }
                }
                                
                pagesPerDeveloper.put(userId, pagesForUser);
                classesPerDeveloper.put(userId, classesForUser);
                triggersPerDeveloper.put(userId, triggersForUser);
                staticResourcesPerDeveloper.put(userId, staticResourcesForUser);
            }
            
            
            for(User user: users) {
                
                String userId = user.Id;
                
                List<ApexPage> pagesToProcess = pagesPerDeveloper.get(userId);
                List<ApexClass> classesToProcess = classesPerDeveloper.get(userId);
                List<ApexTrigger> triggersToProcess = triggersPerDeveloper.get(userId);
                List<StaticResource> staticResourcesToProcess = staticResourcesPerDeveloper.get(userId);
                
                emailBody += '<h2 class=\"example\"> ' + userIdNames.get(userId)  + ' </h2><br/><br/>';
                
                if(pagesToProcess != null && pagesToProcess.size() > 0) {
                    emailBody += '<table width=\"850\" style=\"color:#000000;background-color:#e5eecc;padding-top:8px;padding-bottom:8px;padding-left:10px;padding-right:10px;border:1px solid #d4d4d4;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">';
                    emailBody += '<tr><td>';
                    emailBody += '<h4 class=\"example\">Visualforce Pages</h4>';
                    emailBody += '<table style=\"background-color:#ffffff;border:1px solid #c3c3c3;border-collapse:collapse;\" cellspacing=\"0\" cellpadding=\"0\" border=\"1\" width=\"700\">';
                    emailBody += '<tr>';            
                    emailBody += '<th width=\"375\"">Name</th>';            
                    emailBody += '<th>Last Modified By</th>';            
                    emailBody += '<th>Last Modified Date</th>';
                    emailBody += '<th>Size</th>';
                    emailBody += '</tr>';                                    
                    for(ApexPage page: pagesToProcess) {
                         emailBody += '<tr>';
                         
                             emailBody += '<td> <a href=\"' + orgURL + '/' + page.Id + '" target=\"_blank\">' + page.Name + '</a></td>';
                         
                         emailBody += '<td>' + userIdNames.get(page.LastModifiedById)  + '</td>';
                         emailBody += '<td>' + page.LastModifiedDate  + '</td>';
                         emailBody += '<td>' + '-'  + '</td>';
                         emailBody += '</tr>';
                    }
                    
                    emailBody += '</table>';
                    emailBody += '</td></tr></table><br/><br/>';
                }               
                
                
                if(classesToProcess != null && classesToProcess.size() > 0) {
                    emailBody += '<table width=\"850\" style=\"color:#000000;background-color:#e5eecc;padding-top:8px;padding-bottom:8px;padding-left:10px;padding-right:10px;border:1px solid #d4d4d4;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">';
                    emailBody += '<tr><td>';
                    emailBody += '<h4 class=\"example\">Apex Classes</h4>';
                    emailBody += '<table style=\"background-color:#ffffff;border:1px solid #c3c3c3;border-collapse:collapse;\" cellspacing=\"0\" cellpadding=\"0\" border=\"1\" width=\"700\">';
                    emailBody += '<tr>';            
                    emailBody += '<th width=\"375\"">Name</th>';            
                    emailBody += '<th>Last Modified By</th>';            
                    emailBody += '<th>Last Modified Date</th>';
                    emailBody += '<th>Size</th>';
                    emailBody += '</tr>';                                    
                    
                    for(ApexClass apexclass: classesToProcess) {
                         emailBody += '<tr>';
                         
                             emailBody += '<td> <a href=\"' + orgURL + '/' + apexclass.Id + '" target=\"_blank\">' + apexclass.Name + '</a></td>';
                         
                         emailBody += '<td>' + userIdNames.get(apexclass.LastModifiedById)  + '</td>';
                         emailBody += '<td>' + apexclass.LastModifiedDate  + '</td>';
                         emailBody += '<td>' + apexclass.LengthWithoutComments + '</td>';
                         emailBody += '</tr>';
                    }
                    
                    emailBody += '</table>';
                    emailBody += '</td></tr></table><br/><br/>';
                }
                
                if(triggersToProcess != null && triggersToProcess.size() > 0) {             
                    emailBody += '<table width=\"850\" style=\"color:#000000;background-color:#e5eecc;padding-top:8px;padding-bottom:8px;padding-left:10px;padding-right:10px;border:1px solid #d4d4d4;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">';
                    emailBody += '<tr><td>';
                    emailBody += '<h4 class=\"example\">Apex Triggers</h4>';
                    emailBody += '<table style=\"background-color:#ffffff;border:1px solid #c3c3c3;border-collapse:collapse;\" cellspacing=\"0\" cellpadding=\"0\" border=\"1\" width=\"700\">';
                    emailBody += '<tr>';            
                    emailBody += '<th width=\"375\"">Name</th>';            
                    emailBody += '<th>Last Modified By</th>';            
                    emailBody += '<th>Last Modified Date</th>';
                    emailBody += '<th>Size</th>';
                    emailBody += '</tr>';                                    
                    for(ApexTrigger apextrigger: triggersToProcess) {
                         emailBody += '<tr>';
                        
                             emailBody += '<td> <a href=\"' + orgURL + '/' + apextrigger.Id + '" target=\"_blank\">' + apextrigger.Name + '</a></td>';
                        
                         emailBody += '<td>' + userIdNames.get(apextrigger.LastModifiedById)  + '</td>';
                         emailBody += '<td>' + apextrigger.LastModifiedDate  + '</td>';
                         emailBody += '<td>' + apextrigger.LengthWithoutComments  + '</td>';
                         emailBody += '</tr>';
                    }
                    
                    emailBody += '</table>';
                    emailBody += '</td></tr></table><br/><br/>';
                }

            if(staticResourcesToProcess != null && staticResourcesToProcess.size() > 0) {             
                    emailBody += '<table width=\"850\" style=\"color:#000000;background-color:#e5eecc;padding-top:8px;padding-bottom:8px;padding-left:10px;padding-right:10px;border:1px solid #d4d4d4;\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">';
                    emailBody += '<tr><td>';
                    emailBody += '<h4 class=\"example\">Static Resources</h4>';
                    emailBody += '<table style=\"background-color:#ffffff;border:1px solid #c3c3c3;border-collapse:collapse;\" cellspacing=\"0\" cellpadding=\"0\" border=\"1\" width=\"700\">';
                    emailBody += '<tr>';            
                    emailBody += '<th width=\"375\"">Name</th>';            
                    emailBody += '<th>Last Modified By</th>';            
                    emailBody += '<th>Last Modified Date</th>';
                    emailBody += '</tr>';                                    
                    for(StaticResource sResource: staticResourcesToProcess) {
                         emailBody += '<tr>';
                        
                         emailBody += '<td> <a href=\"' + orgURL + '/' + sResource.Id + '" target=\"_blank\">' + sResource.Name + '</a></td>';
                        
                         emailBody += '<td>' + userIdNames.get(sResource.LastModifiedById)  + '</td>';
                         emailBody += '<td>' + sResource.LastModifiedDate  + '</td>';
                         emailBody += '</tr>';
                    }
                    
                    emailBody += '</table>';
                    emailBody += '</td></tr></table><br/><br/>';
                }
            }
                       
            mail.setHtmlBody(emailBody);    
            
            boolean anyChanges = false;
            if(pages != null && pages.size() > 0) {
              anyChanges = true;
            }
            if(classes != null && classes.size() > 0) {
              anyChanges = true;
            }
            if(triggers != null && triggers.size() > 0) {
              anyChanges = true;
            }
            
            if(staticResources != null && staticResources.size() > 0) {
              anyChanges = true;
            }
            
            
            if(anyChanges) {
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                   
            }
        } catch(Exception ex) {
            System.debug('@@@Error Sending Email');
            System.debug(ex);
        }    
        return null;
    }
}