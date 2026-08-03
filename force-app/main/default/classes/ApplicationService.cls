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

}