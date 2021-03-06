@isTest
private class ExampleConciselyExpressedTest {

    // Note: an annotated version of this test exists, describing some of the changes made:
    //          1-2-ExampleConciselyExpressedTest-Annotated.cls
    
    @testSetup
    static void testSetup() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        contactFactory.create( contactFactory.build() );
    }
    
    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task is created for a contact
    * @result Legitimate Interest Expiry date of contact will be updated
    */
    @isTest
    static void insertOfTaskDescribingAPositiveConversation_againstContact_willExtendContactsLegitimateInterestExpiryDate() {

        Contact originalContact = getContact();

        Test.startTest();
            createTask( originalContact, 'Positive Call' );
        Test.stopTest();

        Contact updatedContact = getContact( originalContact.Id );

        System.assert( updatedContact.Legitimate_Interest_Expiry__c != null
                     , 'Legitimate Interest Expiry date of contact will be updated' );
    }

    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task is created for a contact
    * @result Legitimate Interest Expiry date of contact will not be updated
    */
    @isTest
    static void insertOfTaskNotDescribingAPositiveConversation_againstContact_willNotExtendContactsLegitimateInterestExpiryDate() {

        Contact originalContact = getContact();

        Test.startTest();
            createTask( originalContact, 'Left Message' );
        Test.stopTest();

        Contact updatedContact = getContact( originalContact.Id );

        System.assert( updatedContact.Legitimate_Interest_Expiry__c == null
                     , 'Legitimate Interest Expiry date of contact will not be updated' );
    }
    
    /**
    * Helper function to get one of the available contacts
    */ 
    private static Contact getContact() {
        return [ SELECT Legitimate_Interest_Expiry__c
                 FROM   Contact
                 ORDER BY Id
                 LIMIT 1 ];
    }

    /**
    * Helper function to get a particular contact
    */ 
    private static Contact getContact( Id contactId ) {
        return [ SELECT Legitimate_Interest_Expiry__c
                 FROM   Contact
                 WHERE  Id = :contactId ];
    }

    /**
    * Helper function to create task for contact passed.
    */
    private static Task createTask( Contact contact, String type  ) {
        TaskDataFactory taskFactory = new TaskDataFactory();
        return ( (Task) taskFactory.create( (Task) taskFactory.build( 'Test Task', contact, Date.today(), type ) ) );
    }
}