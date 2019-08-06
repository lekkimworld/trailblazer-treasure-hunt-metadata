trigger Basecamp_QuestionTrigger on Basecamp_Question__c (after insert, before update) {
    // ensure the answer selected is a child of this question
    for (Basecamp_Question__c question : Trigger.new) {
        if (String.isEmpty(question.Answer__c)) continue;
        final List<Basecamp_Answer__c> answers = [SELECT Question__c FROM Basecamp_Answer__c WHERE Id =: question.Answer__c AND Question__c =: question.Id];
        if (answers.isEmpty()) {
            question.addError('Selected answer is not a child of the question');
        }
    }
    
    if (Trigger.isInsert) {
        // build answers for each question
        final List<Basecamp_Answer__c> answers = new List<Basecamp_Answer__c>();
        for (Basecamp_Question__c question : Trigger.new) {
            // get questionnaire data through question
            Basecamp_Question__c questionData = [SELECT Version__r.Questionnaire__r.Number_Answers_Per_Question__c FROM Basecamp_Question__c WHERE Id =: question.Id LIMIT 1];
            
            // build answers
            for (Integer i=0; i<questionData.Version__r.Questionnaire__r.Number_Answers_Per_Question__c; i++) {
                Basecamp_Answer__c answer = new Basecamp_Answer__c(
                    Question__c = question.Id,
                    Text__c = 'Replace with answer text',
                    Sorting__c = i*10
                );
                answers.add(answer);
            }
        }
        INSERT answers;
    }
}