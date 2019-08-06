trigger Basecamp_QuestionnaireResponseTrigger on Basecamp_Questionnaire_Response__c (before insert, before update) {
	// ensure version selected is for the selected questionnaire
	Set<Id> versionIds = new Set<Id>();
    for (Basecamp_Questionnaire_Response__c q : Trigger.new) {
        versionIds.add(q.Version__c);
    }
	Map<Id,Basecamp_Version__c> versions = new Map<Id,Basecamp_Version__c>([SELECT Id, Questionnaire__c FROM Basecamp_Version__c WHERE Id IN :versionIds]);
    for (Basecamp_Questionnaire_Response__c q : Trigger.new) {
        if (q.Questionnaire__c != versions.get(q.Version__c).Questionnaire__c) {
            q.addError('Selected version is not a child record of the selected questionnaire');
        }
    }
}