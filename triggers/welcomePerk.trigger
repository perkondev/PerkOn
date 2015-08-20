// Send a welcome email to each new User
trigger welcomePerk on User (after update) {
  // Step 0: Create a master list to hold the emails we'll send
  List<Messaging.SingleEmailMessage> mails = 
  new List<Messaging.SingleEmailMessage>();
  
  // Query for PermSetAssignment
  List<PermissionSetAssignment> psa = [SELECT AssigneeId, PermissionSetId FROM PermissionSetAssignment WHERE PermissionSetId = '0PSU0000000fZZ2'];
  Set<String> psUsers = new Set<String>();
  for (PermissionSetAssignment p : psa) {
      psUsers.add(p.AssigneeId);
  }
  
  for (User newUser : Trigger.new) {
    System.debug('Checking PermSetAssignment on user');
    if (psUsers.contains(newUser.Id)) {
      // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = 
      new Messaging.SingleEmailMessage();
    
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      sendTo.add(newUser.Email);
      mail.setToAddresses(sendTo);
    
      // Step 3: Set who the email is sent from
      mail.setReplyTo('Provider@PerkOn.com');
      mail.setSenderDisplayName('PerkOn Distribution');
    

      // Step 4. Set email contents - you can use variables!
      mail.setSubject('Your first PerkOn perk is here!');
      String body = 'Dear ' + newUser.FirstName + ', ';
      body += 'Welcome to '+ newUser.CompanyName + '! ';
      body += 'Access your first PerkOn here: ';
      body += '<Link to PerkOn>';
      mail.setHtmlBody(body);
    
      // Step 5. Add your email to the master list
      mails.add(mail);
    } else {
        System.debug('User Id ' + newUser.Id + 'does not have PermSetAssignment 0PSU0000000fZZ2');
    }
  }
  // Step 6: Send all emails in the master list
  Messaging.sendEmail(mails);
}