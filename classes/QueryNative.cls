public class QueryNative {
 
    public List<Account> myAccounts {get; set;} //We will move accouns to this list...
    public List<AccountWrapper> accountList {get; set;} //...from this list
 
    public QueryNative(){
        myAccounts = new List<Account>();
        buildAccountSelectList(); //Builds a list of accounts we can select from
   }
 
    public void buildAccountSelectList(){
        /*Build a simple list of accounts that user can select from. We need to use
        a wrapper class here so we can track what accounts are selected */
        accountList = new List<AccountWrapper>();
 
        for(Account acct : [select Fax, Id, Name, AccountNumber, Phone, Rating, Site, Type, AnnualRevenue, BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode, CreatedById, CreatedDate, Industry, LastActivityDate, LastModifiedById, LastModifiedDate, NumberOfEmployees, OwnerId, Sic, ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode, TickerSymbol, Website from Account where Name != 'Batch Testing' AND Industry != null limit 300]){
            AccountWrapper aw = new AccountWrapper();
            aw.a = acct;
            accountList.add(aw);
        }
    }
 
    public void addSelectedAccounts() {
        List<AccountWrapper> newList = new List<AccountWrapper>();
 
        //Loop through the list of accounts to see if any are selected
        for(AccountWrapper aw : accountList){
 
            if(aw.selected == true){
                //Pretend we do something here that requires all those queried fields
                myAccounts.add(aw.a);
            }else{
                newList.add(aw); //not selected add to newList
            }
        }
 
        //Re-set account list so selected accounts are not displayed in list
        accountList = newList;
    }
 
    /*This is a wrapper class, it basically combines a boolean value which is linked to  a
    checkbox on the page, and an account.*/
    public class AccountWrapper{
        public Account a {get; set;}
        public Boolean selected {get; set;}
 
        public AccountWrapper(){
            selected = false;
        }
    }
}