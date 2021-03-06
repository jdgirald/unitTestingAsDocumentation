@isTest
private class ExampleMoreExpressiveTest {

    // Note: an annotated version of this test exists, describing some of the changes made:
    //          1-1-ExampleMoreExpressiveTest-Annotated.cls
    
    @testSetup
    static void testSetup() {
        Contact contact = new Contact();
        contact.LastName = 'Contact';
        contact.Requires_P125_Completed__c = false;
        contact.Last_Revenue_Expected__c = System.now();
        insert contact;
    }
    
    @isTest
    static void test_LiDateUpdates() {

        Contact originalContact = new Contact();
        originalContact.LastName = 'Contact';
        originalContact.Requires_P125_Completed__c = false;
        originalContact.Last_Revenue_Expected__c = System.now();
        insert originalContact;

        originalContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact ORDER BY Id LIMIT 1];

        Test.startTest();
        
            TaskDataFactory tdf = new TaskDataFactory();
            Task nonLiExtendingTask = tdf.build( 'Not a Legitimate Interest Extending Task', originalContact, Date.today(), 'Left Message' );
            tdf.create( nonLiExtendingTask );
            
            Contact updatedContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :originalContact.Id];
    
            System.assert( updatedContact.Legitimate_Interest_Expiry__c == null, 'Adding a task that does not extend Legitimate Interest, will not update the Legitimate Interest Expiry on the contact' );
            
            Task liExtendingTask = tdf.build( 'Legitimate Interest Extending Task', originalContact, Date.today(), 'Positive Call' );
            tdf.create( liExtendingTask );
            
            updatedContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :originalContact.Id];
            
            System.assert( updatedContact.Legitimate_Interest_Expiry__c != null, 'Adding a task that does extend Legitimate Interest, will update the Legitimate Interest Expiry on the contact' );

        Test.stopTest();
    }
}