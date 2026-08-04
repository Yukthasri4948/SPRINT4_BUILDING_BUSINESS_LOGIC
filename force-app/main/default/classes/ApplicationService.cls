public class ApplicationService {


    public static String submitApplication(
        Id studentId,
        Id jobId
    ){
        
        try {
            List<Application__c> existingApplications =
            [
                SELECT Id
                FROM Application__c
                WHERE Student__c = :studentId
                AND Job__c = :jobId
                LIMIT 1
            ];

            if(!existingApplications.isEmpty()){
                return 'Application already exists';
            }

            Student__c student =
            [
                SELECT Id,
                       CGPA__c
                FROM Student__c
                WHERE Id = :studentId
                LIMIT 1
            ];

            if(student.CGPA__c < 7.0){
                return 'Student does not meet minimum CGPA requirement';
            }

            Application__c application =
            new Application__c();

            application.Student__c = studentId;
            application.Job__c = jobId;
            application.Status__c = 'Submitted';
            application.Application_Date__c = Date.today();

            insert application;

            return 'Application submitted successfully';
        }
        catch(Exception e){
            return 'Application failed: ' + e.getMessage();
        }

    }


    public static void withdrawApplication(Id applicationId){

        Application__c application =
        [
            SELECT Id, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        application.Status__c = 'Withdrawn';

        update application;

    }


    public static void approveApplication(Id applicationId){

        Application__c application =
        [
            SELECT Id, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        application.Status__c = 'Approved';

        update application;

    }


    public static void rejectApplication(Id applicationId){

        Application__c application =
        [
            SELECT Id, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        application.Status__c = 'Rejected';

        update application;

    }


    public static void reopenApplication(Id applicationId){

        Application__c application =
        [
            SELECT Id, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        application.Status__c = 'Submitted';

        update application;

    }


    // Sprint 6: Validate new Applications before saving

    public static void validateNewApplications(
        List<Application__c> applications
    ){

        Set<Id> studentIds = new Set<Id>();

        Set<String> applicationKeys = new Set<String>();

        for(Application__c application : applications){

            if(application.Student__c != null){
                studentIds.add(application.Student__c);
            }

            if(
                application.Student__c != null &&
                application.Job__c != null
            ){

                applicationKeys.add(
                    String.valueOf(application.Student__c) +
                    '-' +
                    String.valueOf(application.Job__c)
                );

            }

        }


        Map<Id, Student__c> studentsById =
        new Map<Id, Student__c>(
            [
                SELECT Id, CGPA__c
                FROM Student__c
                WHERE Id IN :studentIds
            ]
        );


        Set<String> existingApplicationKeys =
        new Set<String>();

        if(!applicationKeys.isEmpty()){

            for(Application__c existingApplication :
                [
                    SELECT Student__c, Job__c
                    FROM Application__c
                    WHERE Student__c IN :studentIds
                ]
            ){

                String key =
                    String.valueOf(existingApplication.Student__c) +
                    '-' +
                    String.valueOf(existingApplication.Job__c);

                existingApplicationKeys.add(key);

            }

        }


        for(Application__c application : applications){

            if(application.Student__c == null){

                application.addError(
                    'Student is required.'
                );

                continue;
            }


            if(application.Job__c == null){

                application.addError(
                    'Job is required.'
                );

                continue;
            }


            Student__c student =
            studentsById.get(application.Student__c);


            if(
                student != null &&
                student.CGPA__c != null &&
                student.CGPA__c < 7.0
            ){

                application.addError(
                    'Student does not meet minimum CGPA requirement.'
                );

            }


            String currentKey =
                String.valueOf(application.Student__c) +
                '-' +
                String.valueOf(application.Job__c);


            if(existingApplicationKeys.contains(currentKey)){

                application.addError(
                    'Application already exists.'
                );

            }

        }

    }

}