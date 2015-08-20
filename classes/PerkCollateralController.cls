public with sharing class PerkCollateralController {
    
    public String[] folders = new String[]{};

    public String selectedFolder { get; set; }

    public List<SelectOption> getFolders() { 
        List<Folder> folders = [SELECT Name, Id FROM Folder WHERE Type='Document' AND Name LIKE 'PerkOn %'];
        List<SelectOption> options = new List<SelectOption>();
        
        // Strip Folder ID by 3 chars for correct matching
        for (Folder f : folders) {
            if (folders.size() > 0) {   
                options.add(new SelectOption(f.Id, f.Name));
            }
        }
        return options;

    } 
    
    public void setFolders (String[] folders) {
        this.folders = folders;
    }

    public PageReference renderDocuments() {
        documents = [SELECT Description, Id, FolderId, Name, Url FROM Document];
        return null;
    }


    public List<Document> documents{set;get;}
    public Document document 
    {
      get 
      {
        if (document == null)
          document = new Document();
          return document;
      }
      set;
    }
    
    public void upload() {
        document.AuthorId = UserInfo.getUserId();
            document.FolderId = selectedFolder;
            try {
               insert document;
            } catch (DMLException e) {
               System.debug ('Error uploading document');
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error'));
            } finally {
               document.body = null;
               document = new Document();
               documents = [SELECT Description, BodyLength, Body, Id, FolderId, Name, Url FROM Document];
               //List<Folder> PerkOnFolders = [SELECT Name, Id FROM Folder WHERE Type='Document' AND Name LIKE 'PerkOn %'];
               //documents = [SELECT Description, Id, FolderId, Name, Url FROM Document WHERE FolderId IN :PerkOnFolders];
            }
    }
    
}
