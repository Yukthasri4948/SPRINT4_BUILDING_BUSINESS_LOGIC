@IsTest
private class PlacementCategoryBatchTest {

    @IsTest
    static void testPlacementCategoryBatch() {

        Student__c student = new Student__c(
            Name = 'Test Student',
            CGPA__c = 8.5
        );
        insert student;

        Job__c job = new Job__c(
            Name = 'Test Job',
            Minimum_CGPA__c = 7.0
        );
        insert job;

        Application__c application = new Application__c(
            Student__c = student.Id,
            Job__c = job.Id,
            Status__c='Selected'
        );
        insert application;

        Test.startTest();

        PlacementCategoryBatch batch = new PlacementCategoryBatch();
        Database.executeBatch(batch, 200);

        Test.stopTest();

        Application__c updatedApplication = [
            SELECT Id, Placement_Category__c
            FROM Application__c
            WHERE Id = :application.Id
        ];

        System.assertEquals(
            'Placed',
            updatedApplication.Placement_Category__c,
            'Application should be marked as Placed'
        );
    }
}