public with sharing class ExampleController {
    
    private final Id perkId;
    public final String perkName {get;set;}
    transient DateTime currentDateTime;
    
    public ExampleController(ApexPages.StandardController controller) {
        Perk__c perk = [SELECT Id, Name FROM Perk__c WHERE Id =: ApexPages.currentPage().getParameters().get('id')];
        perkId = perk.Id;
        perkName = perk.Name;
    }
    
    public String getCurrentDateTime() {
        if (currentDateTime == null) currentDateTime = System.now();
        return '' + currentDateTime;
    }
    
    public PageReference save() {
        Perk__c myPerk = [select name from Perk__c WHERE Id =: perkId];
        myPerk.name = perkName ;
        update myPerk;
        return null;
    }
    
    public Blob file {get;set;} 
    public String UploadedfileName{get;set;}
    
    public void submit() { 
        Attachment att = new Attachment(); 
        try {        
            if (file != null){             
                att.Name = UploadedfileName; 
                att.Body = file;
                att.ParentId = perkId; 
                att.Description = 'File Uploaded'; 
                insert att;     
                file = null;
                att  = null;
            }
        } catch (Exception e) {
            file = null;
            att  = null;
        }
    }

}