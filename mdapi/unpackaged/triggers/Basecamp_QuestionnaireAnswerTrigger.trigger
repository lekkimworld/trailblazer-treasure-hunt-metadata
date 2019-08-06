trigger Basecamp_QuestionnaireAnswerTrigger on Basecamp_Questionnaire_Answer__c (before insert, before update) {
    List<Id> ids = new List<Id>();
    for (Basecamp_Questionnaire_Answer__c answer : Trigger.new) {
        ids.add(answer.Question__c);
    }
    Map<Id, Basecamp_Question__c> questionMap = new Map<Id, Basecamp_Question__c>([SELECT Id, Answer__c FROM Basecamp_Question__c WHERE Id IN :ids]);
    for (Basecamp_Questionnaire_Answer__c answer : Trigger.new) {
        answer.Correct__c = (answer.Answer__c == questionMap.get(answer.Question__c).Answer__c);
    }
}