public class GNE_Generate_Package_XML {
 
  public Boolean fieldNamesSelected {
   get {
    If(fieldNames != null && fieldNames.size() > 0) {
     return true;
    }
    return false;
   }
   set;
  }
 
   public String containsString1 {
    get {
      if(containsString1 == null) {
       return 'MPS';
      }
      return containsString1;
    }
    set;
   }

   public String containsString2 {
    get {
      if(containsString2 == null) {
       return '';
      }
      return containsString2;
    }
    set;
   }

   public String containsString3 {
    get;
    set;
   }


    public PageReference loadFields() {
       getSelectedObjectsFieldNames();    
       return null;
    }


    public PageReference addSelectedField() {
        fieldNames.add(new FieldWrapper(objectValForField + '.' + fieldVal));     
        return null;
    }


    public PageReference addSelectedObject() {
        objectNames.add(new ObjectWrapper(val)); 
        return null;
    }


    public PageReference updateMetadata() {
    
        pages.clear();
        classes.clear();
        triggers.clear();
        staticResources.clear();
    
        aPages.clear();
        aClasses.clear();
        aTriggers.clear();
        aStaticResources.clear();
        
        selPages.clear();
        selClasses.clear();
        selTriggers.clear();
        selStaticResources.clear();
        
     String pageSOQL = 'SELECT Id, Name, ControllerType, ControllerKey,  CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexPage where LastModifiedDate = LAST_N_DAYS:' + lastNumberOfDays + ' '; 
     //if(includeTodaysChanges) {
     // pageSOQL += ' or LastModifiedDate = TODAY '; 
     //}
     pageSOQL += ' order by LastModifiedById Desc';
      
      
     String classSOQL = 'SELECT Id, Name,  LengthWithoutComments, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexClass where LastModifiedDate = LAST_N_DAYS:' + lastNumberOfDays + ' '; 
     //if(includeTodaysChanges) {
     // classSOQL += ' or LastModifiedDate = TODAY '; 
     //}
     classSOQL += ' order by LastModifiedById Desc';
     
     String triggerSOQL = 'SELECT Id, Name, TableEnumOrId,  LengthWithoutComments, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById from ApexTrigger where LastModifiedDate = LAST_N_DAYS:' + lastNumberOfDays + ' '; 
    // if(includeTodaysChanges) {
     // triggerSOQL += ' or LastModifiedDate = TODAY '; 
     //}
     triggerSOQL += ' order by LastModifiedById Desc';     
     
     String staticResourcesSOQL = 'SELECT BodyLength,CacheControl,ContentType,Id,LastModifiedById,LastModifiedDate,Name FROM StaticResource where LastModifiedDate = LAST_N_DAYS:' + lastNumberOfDays + ' '; 
    // if(includeTodaysChanges) {
     // staticResourcesSOQL += ' or LastModifiedDate = TODAY '; 
     //}
     staticResourcesSOQL += ' order by LastModifiedById Desc';             
  
     aPages = Database.query(pageSOQL);   
     aClasses = Database.query(classSOQL);
     aTriggers = Database.query(triggerSOQL);
     aStaticResources = Database.query(staticResourcesSOQL);

         List<String> userIds = new List<String>();
         if(aPages != null) {
             for(ApexPage page: aPages ) {
                userIds.add(page.LastModifiedById);
             }
         }
         
         if(aClasses != null) {
             for(ApexClass apexclass: aClasses ) {
                userIds.add(apexclass.LastModifiedById);
             }
         }         

         if(aTriggers != null) {
             for(ApexTrigger apextrigger: aTriggers ) {
                userIds.add(apextrigger.LastModifiedById);
             }
         }
         
         if(aStaticResources != null) {
             for(StaticResource staticResource: aStaticResources ) {
                userIds.add(staticResource.LastModifiedById);
             }
         }

         users = [SELECT Id, Name, Email from User where Id in :userIds];
         if(users != null) {
             Integer i = 0;
             for(User user: users) {
                 userIdNames.put(user.Id, user.Name);
                 i++;
             }
         }   
         
         
         if(aPages != null) {
             for(ApexPage page: aPages ) {
               if(containsString1 != null && !containsString1.trim().equals('')) {
                 if(page.Name.contains(containsString1)) {
                   pages.add(new PageWrapper(page));
                 }
               }
               
               if(containsString2 != null && !containsString2.trim().equals('')) {
                 if(page.Name.contains(containsString2)) {
                   pages.add(new PageWrapper(page));
                 }
               }
             
               if((containsString1 == null || containsString1.trim().equals('')) &&
                        (containsString2 == null || containsString2.trim().equals(''))) {
                       pages.add(new PageWrapper(page));
               }  
             
             }
         }
         
         if(aClasses != null) {
             for(ApexClass apexclass: aClasses ) {
                 
                   if(containsString1 != null && !containsString1.trim().equals('')) {
                     if(apexclass.Name.contains(containsString1)) {
                       classes.add(new ClassWrapper(apexclass));
                     }
                   }
                   
                   if(containsString2 != null && !containsString2.trim().equals('')) {
                     if(apexclass.Name.contains(containsString2)) {
                       classes.add(new ClassWrapper(apexclass));
                     }
                   }   
                   
                    if((containsString1 == null || containsString1.trim().equals('')) &&
                        (containsString2 == null || containsString2.trim().equals(''))) {
                       classes.add(new ClassWrapper(apexclass));
                    }           
             }
         }         

         if(aTriggers != null) {
             for(ApexTrigger apextrigger: aTriggers ) {
                
                   if(containsString1 != null && !containsString1.trim().equals('')) {
                     if(apextrigger.Name.contains(containsString1)) {
                       triggers.add(new TriggerWrapper(apextrigger));
                     }
                   }
                   
                   if(containsString2 != null && !containsString2.trim().equals('')) {
                     if(apextrigger.Name.contains(containsString2)) {
                       triggers.add(new TriggerWrapper(apextrigger));
                     }
                   }   
                   
                    if((containsString1 == null || containsString1.trim().equals('')) &&
                        (containsString2 == null || containsString2.trim().equals(''))) {
                       triggers.add(new TriggerWrapper(apextrigger));
                    }               
                
             }
         }    
         
         if(aStaticResources != null) {
             for(StaticResource staticResource: aStaticResources ) {
                
                
         if(containsString1 != null && !containsString1.trim().equals('')) {
                     if(staticResource.Name.contains(containsString1)) {
                       staticResources.add(new StaticResourceWrapper(staticResource));
                     }
                   }
                   
                   if(containsString2 != null && !containsString2.trim().equals('')) {
                     if(staticResource.Name.contains(containsString2)) {
                      staticResources.add(new StaticResourceWrapper(staticResource));
                     }
                   }   
                   
                    if((containsString1 == null || containsString1.trim().equals('')) &&
                        (containsString2 == null || containsString2.trim().equals(''))) {
                       staticResources.add(new StaticResourceWrapper(staticResource));
                    }                               
             }
         }      
         
         
                     
        return null;
    }


    public Boolean includeTodaysChanges { 
    
      get { 
        if(includeTodaysChanges == null) {
         return true;
        }
       
        return includeTodaysChanges;
      } set; 
    }

    public Datetime startDate { 
        get {
          if(startDate == null) {
            return datetime.now();
          }
          return startDate;
        }
        set; 
    }
    public Datetime endDate { 
    
        get {
          if(endDate == null) {
            return datetime.now();
          }
          return endDate;
        }
        set; 
    }

    public Integer lastNumberOfDays {
    
    get {
      if(lastNumberOfDays  == null) {
        return 10;
      }
      return lastNumberOfDays;
    }
    
    set;
    
    }


    public List<ApexPage> aPages {
        get {
            if(aPages == null) {
                aPages = new List<ApexPage>();
            }
            return aPages ;
        }
        set;
    }
    
    public List<ApexClass> aClasses {
        get {
            if(aClasses == null) {
                aClasses = new List<ApexClass>();
            }
            return aClasses ;
        }
        set;
    }    
    
    public List<ApexTrigger> aTriggers {
        get {
            if(aTriggers == null) {
                aTriggers = new List<ApexTrigger>();
            }
            return aTriggers ;
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
    
    
   public List<ApexPage> selPages {
        get {
            if(selPages == null) {
                selPages = new List<ApexPage>();
            }
            return selPages ;
        }
        set;
    }
    
    public List<ApexClass> selClasses {
        get {
            if(selClasses == null) {
                selClasses = new List<ApexClass>();
            }
            return selClasses ;
        }
        set;
    }    
    
    public List<ApexTrigger> selTriggers {
        get {
            if(selTriggers  == null) {
                selTriggers = new List<ApexTrigger>();
            }
            return selTriggers ;
        }
        set;
    }        


    public List<StaticResource> selStaticResources {
        get {
            if(selStaticResources == null) {
                selStaticResources = new List<StaticResource>();
            }
            return selStaticResources ;
        }
        set;
    }   

   public List<PageWrapper> pages {
        get {
            if(pages == null) {
                pages = new List<PageWrapper>();
            }
            return pages;
        }
        set;
    }
    
    public List<ClassWrapper> classes {
        get {
            if(classes == null) {
                classes = new List<ClassWrapper>();
            }
            return classes;
        }
        set;
    }    
    
    public List<TriggerWrapper> triggers {
        get {
            if(triggers == null) {
                triggers = new List<TriggerWrapper>();
            }
            return triggers;
        }
        set;
    }
    
    public List<StaticResourceWrapper> staticResources {
        get {
            if(staticResources == null) {
                staticResources = new List<StaticResourceWrapper>();
            }
            return staticResources ;
        }
        set;
    }    
    
    
    public String val {get;set;}
    
    public String objectValForField {get;set;}

     
    public String fieldVal {get;set;}
    
    public List<SelectOption> getName()
    {
      List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values(); 
      Map<String, String> objects = new Map<String, String>();
      for(Schema.SObjectType f : gd)
      {      
        objects.put(f.getDescribe().getName(),f.getDescribe().getLabel());
      }
      
      Set<String> objectKeyset = objects.keySet();
      List<String> objectKeys = new List<String>();
      Integer count = 0;
      for(String objectKey : objectKeyset) {
        if(count == 1000) {
            break;
        }
        objectKeys.add(objectKey);
        count++;
      }
      objectKeys.sort();
      
      List<SelectOption> options = new List<SelectOption>();
      
      for(String objectKey : objectKeys )
      {
         //if(objectKey.endsWith('__c')) {      
           options.add(new SelectOption(objectKey, objects.get(objectKey)));
         //}
      }
      return options;
     }    
     


    public List<SelectOption> getSelectedObjectsFieldNames()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(objectValForField == null || objectValForField == '')
        {
          options.add(new SelectOption('Select Object First', 'Select Object First'));
          return options;         
        }     
                  
        SObjectType objToken = Schema.getGlobalDescribe().get(objectValForField);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        
        Set<String> fieldSet = fields.keySet();
      List<String> fieldKeys = new List<String>();
      for(String fieldKey : fieldSet ) {
        fieldKeys.add(fieldKey );
      }
      fieldKeys.sort();        
        
        
        for(String s: fieldKeys)
        {
            SObjectField fieldToken = fields.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            options.add(new SelectOption(selectedField.getName(), selectedField.getLabel()));
        }      
        return options;
     }          
    public List<ObjectWrapper> objectNames {
        get {
            if(objectNames == null) {
                objectNames = new List<ObjectWrapper>();
            }
            return objectNames ;
        }
        set;
    } 

    public List<FieldWrapper> fieldNames {
        get {
            if(fieldNames == null) {
                fieldNames = new List<FieldWrapper>();
            }
            return fieldNames;
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

  public List<Code_Conflict__c> codeConflicts {
    get {
      if(codeConflicts == null) {
       codeConflicts = new List<Code_Conflict__c>();
      }
      
      return codeConflicts;
    }
    set;
  }

  public List<User> allAdminUsers {
    get {
      if(allAdminUsers == null) {
       allAdminUsers = new List<User>();
      }
      
      return allAdminUsers;
    }
    set;
  }

    Map<String, String> nameEmailIds {
        get {
            if(nameEmailIds == null) {
                nameEmailIds = new Map<String, String>();
            }
            return nameEmailIds;
        }
        set;
    }

  
  public GNE_Generate_Package_XML() {
      updateMetadata();
      
      codeConflicts = [SELECT Name, Track__c, Code_Name__c,Code_Type__c,Conflicted_By_Email__c,Conflicted_By__c,Id,Locked_By_Email__c,
                            Locked_By__c,Locked__c FROM Code_Conflict__c order by Track__c, Code_Type__c ];
                             
      allAdminUsers = [SELECT Id, Name, Email FROM User where Profile_Name_gne__c  LIKE '%PT1%'];
      
      if(allAdminUsers != null && allAdminUsers.size() > 0) {
        for(User u : allAdminUsers) {
          originalValues.add(u.Name);
          nameEmailIds.put(u.Name, u.Email);
        }
      }
      
      
        leftselected = new List<String>();
        rightselected = new List<String>();
        leftvalues.addAll(originalValues);      
        
  }
  
  

  public class ObjectWrapper {
     public Boolean isSelected {get;set;}
     public String aObject {get;set;}

     public ObjectWrapper (String aObject){
          this.aObject = aObject;
          isSelected = true;
     }
  }
  

  public class FieldWrapper {
     public Boolean isSelected {get;set;}
     public String aField {get;set;}

     public FieldWrapper (String aField ){
          this.aField = aField ;
          isSelected = true;
     }
  }   
    
  public class PageWrapper {
     public Boolean isSelected {get;set;}
     public ApexPage aPage {get;set;}

     public PageWrapper (ApexPage aPage){
          this.aPage= aPage;
          isSelected = false;
     }
  }


  public class ClassWrapper {
     public Boolean isSelected {get;set;}
     public ApexClass aClass {get;set;}

     public ClassWrapper (ApexClass aClass ){
          this.aClass = aClass ;
          isSelected = false;
     }
  }


  public class TriggerWrapper {
     public Boolean isSelected {get;set;}
     public ApexTrigger aTrigger {get;set;}

     public TriggerWrapper (ApexTrigger aTrigger ){
          this.aTrigger = aTrigger ;
          isSelected = false;
     }
  }
 
  public class StaticResourceWrapper {
     public Boolean isSelected {get;set;}
     public StaticResource aStaticResource {get;set;}

     public StaticResourceWrapper (StaticResource aStaticResource  ){
          this.aStaticResource  = aStaticResource  ;
          isSelected = false;
     }
  } 
 
    public PageReference generatePackageXML() {

   
        selPages.clear();
        selClasses.clear();
        selTriggers.clear();
        selStaticResources.clear();
        
        for(PageWrapper pWrapper : pages){
               if(pWrapper.isSelected){    
                 selPages.add(pWrapper.aPage);
               }
        }
        
        for(ClassWrapper cWrapper : classes){
               if(cWrapper.isSelected){    
                 selClasses.add(cWrapper.aClass);
               }
        }
        
         for(TriggerWrapper tWrapper : triggers){
               if(tWrapper.isSelected){    
                 selTriggers.add(tWrapper.aTrigger);
               }
        }      
        
         for(StaticResourceWrapper sWrapper : staticResources){
               if(sWrapper.isSelected){    
                 selStaticResources.add(sWrapper.aStaticResource);
               }
        }                    
        
        return null;
    }
    
    
    public PageReference selectAll() {

   
        for(PageWrapper pWrapper : pages){
              pWrapper.isSelected = true;
              selPages.add(pWrapper.aPage);
        }
        
        for(ClassWrapper cWrapper : classes){
               cWrapper.isSelected = true;   
                 selClasses.add(cWrapper.aClass);
               
        }
        
         for(TriggerWrapper tWrapper : triggers){
               tWrapper.isSelected = true;
                 selTriggers.add(tWrapper.aTrigger);
               
        }      
        
         for(StaticResourceWrapper sWrapper : staticResources){
               sWrapper.isSelected = true;
                 selStaticResources.add(sWrapper.aStaticResource);
               
        }                    
        
        return null;
    }    
    
    
    public PageReference lockSelectdComponents() {
    
        selPages.clear();
        selClasses.clear();
        selTriggers.clear();
        selStaticResources.clear();    
        
        for(PageWrapper pWrapper : pages){
               if(pWrapper.isSelected){    
                 selPages.add(pWrapper.aPage);
               }
        }
        
        for(ClassWrapper cWrapper : classes){
               if(cWrapper.isSelected){    
                 selClasses.add(cWrapper.aClass);
               }
        }
        
         for(TriggerWrapper tWrapper : triggers){
               if(tWrapper.isSelected){    
                 selTriggers.add(tWrapper.aTrigger);
               }
        }      
        
         for(StaticResourceWrapper sWrapper : staticResources){
               if(sWrapper.isSelected){    
                 selStaticResources.add(sWrapper.aStaticResource);
               }
        }                 
    
       List<Code_Conflict__c> codeConflictsSelected = new List<Code_Conflict__c>();
       Code_Conflict__c cc = new Code_Conflict__c();

   
       
        for(ApexPage pWrapper : selPages){
          cc = new Code_Conflict__c();
          cc.Locked__c = true;
          if(selectedTrack != null && !selectedTrack.equals('Other')) {
            cc.Track__c = selectedTrack;
          } else {
            cc.Track__c = otherTrack;
          }
          cc.Locked_By__c = selectedUsers();
          cc.Locked_By_Email__c = selectedUsersEmail();
          cc.Code_Name__c = pWrapper.Name;
          cc.Code_Type__c = 'Page';
          codeConflictsSelected.add(cc);
        }
        
        for(ApexClass cWrapper : selClasses){
          cc = new Code_Conflict__c();
          cc.Locked__c = true;
          if(selectedTrack != null && !selectedTrack.equals('Other')) {
            cc.Track__c = selectedTrack;
          } else {
            cc.Track__c = otherTrack;
          }
          cc.Locked_By__c = selectedUsers();
          cc.Locked_By_Email__c = selectedUsersEmail();
          cc.Code_Name__c = cWrapper.Name;
          cc.Code_Type__c = 'Class';
          codeConflictsSelected.add(cc);
              
        }
        
         for(ApexTrigger tWrapper : selTriggers){
          cc = new Code_Conflict__c();
          cc.Locked__c = true;
          if(selectedTrack != null && !selectedTrack.equals('Other')) {
            cc.Track__c = selectedTrack;
          } else {
            cc.Track__c = otherTrack;
          }
          cc.Locked_By__c = selectedUsers();
          cc.Locked_By_Email__c = selectedUsersEmail();
          cc.Code_Name__c = tWrapper.Name;
          cc.Code_Type__c = 'Trigger';
          codeConflictsSelected.add(cc);
               
        }      
        
         for(StaticResource sWrapper : selStaticResources){
          cc = new Code_Conflict__c();
          cc.Locked__c = true;
          if(selectedTrack != null && !selectedTrack.equals('Other')) {
            cc.Track__c = selectedTrack;
          } else {
            cc.Track__c = otherTrack;
          }
          cc.Locked_By__c = selectedUsers();
          cc.Locked_By_Email__c = selectedUsersEmail();
          cc.Code_Name__c = sWrapper.Name;
          cc.Code_Type__c = 'Static Resource';
          codeConflictsSelected.add(cc);
              
        }                   
        
        
        try {
            insert codeConflictsSelected;
        } catch(Exception ex) {
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'The component you selected to lock is already been locked. Please choose another component. If you want you can edit the existing code conflict item and update.'));
        } 
 
         
      codeConflicts = [SELECT Name, Track__c, Code_Name__c,Code_Type__c,Conflicted_By_Email__c,Conflicted_By__c,Id,Locked_By_Email__c,
                            Locked_By__c,Locked__c FROM Code_Conflict__c order by Track__c, Code_Type__c];
        
        
        return null;
    }        
 
 
    public String selectedUsers() {
      String lockedByUsers = '';
      for(String selUser : rightvalues ) {
        lockedByUsers += (selUser + ';');
      }
      return lockedByUsers;
    }
 
    public String selectedUsersEmail() {
      String lockedByUsers = '';
      for(String selUser : rightvalues ) {
        lockedByUsers += (nameEmailIds.get(selUser) + ';');
      }
      return lockedByUsers;
    } 
 
  //multiselect
  
    Set<String> originalvalues = new Set<String>();
    Public List<string> leftselected{get;set;}
    Public List<string> rightselected{get;set;}
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    
    
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
    
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }

    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }

    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    
   public String selectedTrack {
    get;
    set;
   }
   
   public String otherTrack {
    get;
    set;
   }
      
    public List<SelectOption> getTracks()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Code_Conflict__c.Track__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }   
       options.add(new SelectOption('Other', 'Other'));
       return options;
     }

}