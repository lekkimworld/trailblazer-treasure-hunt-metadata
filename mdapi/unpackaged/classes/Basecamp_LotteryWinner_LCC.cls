public class Basecamp_LotteryWinner_LCC {
    @AuraEnabled
    public static List<String> getLotteryParticipants(String recordId) {
        final List<String> lottery_handles = new List<String>();
        for (List<Basecamp_Questionnaire_Response__c> responses : [SELECT Account__r.PersonEmail FROM Basecamp_Questionnaire_Response__c where Version__c=: recordId]) {
            for (Basecamp_Questionnaire_Response__c response : responses) {
                String email = response.Account__r.PersonEmail;
                if (String.isEmpty(email)) continue;
                Integer idx = email.indexOf('@');
                lottery_handles.Add(email.substring(0, idx));
            }
        }
        System.debug('Found <' + lottery_handles.size() + '> responses');
        return lottery_handles;
    }
}