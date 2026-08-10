public class ExternalPlacementSyncJob implements Queueable {

    private Id offerLetterId;

    public ExternalPlacementSyncJob(Id offerLetterId) {
        this.offerLetterId = offerLetterId;
    }

    public void execute(QueueableContext context) {

        Offer_Letter__c offerLetter = [
            SELECT Id,
                   Name,
                   Application__c,
                   Application__r.Student__c,
                   Application__r.Job__c,
                   Offer_Date__c,
                   Offer_Status__c
            FROM Offer_Letter__c
            WHERE Id = :offerLetterId
            LIMIT 1
        ];

        System.debug('======================================');
        System.debug('EXTERNAL PLACEMENT SYNC STARTED');
        System.debug('Offer Letter: ' + offerLetter.Name);
        System.debug('Student: ' + offerLetter.Application__r.Student__c);
        System.debug('Application: ' + offerLetter.Application__c);
        System.debug('Job: ' + offerLetter.Application__r.Job__c);
        System.debug('Offer Status: ' + offerLetter.Offer_Status__c);

        // Simulating successful external synchronisation.
        System.debug('Placement information synchronised successfully.');

        // Chain the next Queueable job.
        System.enqueueJob(
            new PlacementNotificationJob(offerLetterId)
        );

        System.debug('PlacementNotificationJob has been queued.');
        System.debug('======================================');
    }
}