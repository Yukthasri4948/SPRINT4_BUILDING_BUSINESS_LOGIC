public class PlacementNotificationJob implements Queueable {

    private Id offerLetterId;

    public PlacementNotificationJob(Id offerLetterId) {
        this.offerLetterId = offerLetterId;
    }

    public void execute(QueueableContext context) {

        Offer_Letter__c offerLetter = [
            SELECT Id,
                   Name,
                   Application__c,
                   Application__r.Student__c,
                   Application__r.Job__c,
                   Offer_Status__c
            FROM Offer_Letter__c
            WHERE Id = :offerLetterId
            LIMIT 1
        ];

        System.debug('======================================');
        System.debug('PLACEMENT NOTIFICATION JOB STARTED');
        System.debug('Offer Letter: ' + offerLetter.Name);
        System.debug('Student: ' + offerLetter.Application__r.Student__c);
        System.debug('Job: ' + offerLetter.Application__r.Job__c);
        System.debug('Status: ' + offerLetter.Offer_Status__c);

        // Simulating notification preparation.
        System.debug('Placement notification prepared successfully.');

        System.debug('PLACEMENT NOTIFICATION JOB COMPLETED');
        System.debug('======================================');
    }
}