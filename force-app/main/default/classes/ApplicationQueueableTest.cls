@IsTest
private class ApplicationQueueableTest {

    @IsTest
    static void testApplicationQueueable() {

        Student__c student = new Student__c(
            Name = 'Test Student',
            CGPA__c = 8.5
        );
        insert student;

        Job__c job = new Job__c(
            Name = 'Test Job',
            Minimum_CGPA__c = 7.0,
            Job_Status__c = 'Open'
        );
        insert job;

        Application__c applicationRecord = new Application__c(
            Student__c = student.Id,
            Job__c = job.Id,
            Status__c = 'Applied',
            Application_Date__c = Date.today()
        );
        insert applicationRecord;

        Test.startTest();

        System.enqueueJob(
            new ApplicationQueueable(applicationRecord.Id)
        );

        Test.stopTest();

        Application__c result = [
            SELECT Id, Status__c
            FROM Application__c
            WHERE Id = :applicationRecord.Id
        ];

        System.assertEquals(
            'Applied',
            result.Status__c
        );
    }
}
