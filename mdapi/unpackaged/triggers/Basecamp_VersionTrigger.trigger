trigger Basecamp_VersionTrigger on Basecamp_Version__c (after insert, after update) {
    if (Trigger.isInsert) {
        // loop versions and create questions for each
        final List<Basecamp_Question__c> questions = new List<Basecamp_Question__c>();
        final Map<Id, Basecamp_Questionnaire__c> questionnaireByVersionId = new Map<Id, Basecamp_Questionnaire__c>();
        for (Basecamp_Version__c version : Trigger.new) {
            // get the questionaire and add to map
            final Basecamp_Questionnaire__c questionnaire = [SELECT Number_Questions__c, Number_Answers_Per_Question__c FROM Basecamp_Questionnaire__c WHERE Id =: version.Questionnaire__c LIMIT 1];
            questionnaireByVersionId.put(version.Id, questionnaire);
            
            // build questions
            for (Integer i=0; i<questionnaire.Number_Questions__c; i++) {
                Basecamp_Question__c q = new Basecamp_Question__c(
                    Version__c = version.Id,
                    Text__c = 'Replace with question text',
                    Sorting__c = i*10
                );
                questions.add(q);
            }
        }
        INSERT questions;
    }
    
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Basecamp_Version__c version : Trigger.new) {
            if (Trigger.isUpdate) {
                // make sure not going back in status
                Basecamp_Version__c oldVersion = Trigger.oldMap.get(version.Id);
                List<Schema.PicklistEntry> plEntries = Basecamp_Version__c.Status__c.getDescribe().getPicklistValues();
                Integer idxOld = -1;
                Integer idxNew = -1;
                Integer idx = 0;
                for (Schema.PicklistEntry pl : plEntries) {
                    if (!pl.isActive()) continue;
                    if (pl.getValue() == oldVersion.Status__c) {
                        idxOld = idx;
                    }
                    if (pl.getValue() == version.Status__c) {
                        idxNew = idx;
                    }
                    idx++;
                }
                if (idxNew < idxOld) version.addError('Cannot go to a lesser status');
            }
            
            // ignore if not active
            if (version.Status__c != 'Active') continue;
            
            // get other active version for questionnaire
            final List<Basecamp_Version__c> activeVersions = [SELECT Id, Status__c FROM Basecamp_Version__c WHERE Id !=: version.Id AND Questionnaire__c =: version.Questionnaire__c AND Status__c='Active'];
            if (activeVersions.isEmpty()) continue;
            for (Basecamp_Version__c activeVersion : activeVersions) {
                activeVersion.Status__c = 'Retired';
            }
            UPDATE activeVersions;
        }
    }
}