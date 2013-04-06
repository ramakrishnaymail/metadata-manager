global class GNE_TodayChanges {


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

    public List<StaticResource> aStaticResources {
        get {
            if(aStaticResources == null) {
                aStaticResources = new List<StaticResource>();
            }
            return aStaticResources ;
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
    
    public GNE_TodayChanges() {
        //TODAY
        //YESTERDAY
        //THIS_WEEK
        //LAST_WEEK
        //THIS_MONTH
        //LAST_MONTH
        //LAST_90_DAYS
        //THIS_YEAR
        //LAST_YEAR
            
         pages = [SELECT Id, Name, ControllerType, ControllerKey,  CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexPage where LastModifiedDate = TODAY order by LastModifiedById Desc ];   
         classes = [SELECT Id, Name,  LengthWithoutComments, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexClass where LastModifiedDate = TODAY order by LastModifiedById Desc];
         triggers = [SELECT Id, Name, TableEnumOrId,  LengthWithoutComments, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexTrigger  where LastModifiedDate = TODAY order by LastModifiedById Desc];
         aStaticResources = [SELECT BodyLength,CacheControl,ContentType,Id,LastModifiedById,LastModifiedDate,Name FROM StaticResource where LastModifiedDate = TODAY order by LastModifiedById Desc];
         
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
         
         if(aStaticResources != null) {
             for(StaticResource aStaticResource: aStaticResources) {
                userIds.add(aStaticResource.LastModifiedById);
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
    
   

}