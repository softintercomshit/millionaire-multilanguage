#import "QuestionLangService.h"
#import "AccessLayer.h"
#import "DifficultyService.h"
#import "LanguageService.h"
#import "QuestionModelService.h"

@implementation QuestionLangService

+(QuestionLang *)getQuestionForDifficulty:(int)level {
    Difficulty *difficulty = [DifficultyService getDifficultyByLevel:level];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *languageName = [defaults stringForKey:@"localization"];
    if(!languageName) { languageName = @"en"; }
    Language *language = [LanguageService getLanguageByName:languageName];
    
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<QuestionLang*> *formatRequest = [QuestionLang fetchRequest];
    formatRequest.predicate = [NSPredicate predicateWithFormat:@"(used == %d) and (language == %@) and (question.difficulty == %@)", false, language, difficulty];
    NSArray<QuestionLang*> *questions = [context executeFetchRequest:formatRequest error:nil];
    
    if (!questions.count) {
        formatRequest.predicate = [NSPredicate predicateWithFormat:@"(language == %@) and (question.difficulty == %@)", language, difficulty];
        questions = [context executeFetchRequest:formatRequest error:nil];
        [questions setValue:@(false) forKey:@"used"];
        [context save:nil];
        return [self getQuestionForDifficulty:level];
    }
    
    NSInteger index = [self randomIndex:questions.count];
    return questions[index];
}

+(QuestionLang *)getQuestionById:(int)questionId {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<QuestionLang*> *formatRequest = [QuestionLang fetchRequest];
    formatRequest.predicate = [NSPredicate predicateWithFormat:@"question_id == %d", questionId];
    QuestionLang *question = [context executeFetchRequest:formatRequest error:nil].firstObject;
    
    return question;
}

+(QuestionLang *)createQuestionModel:(NSDictionary *)item {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    NSNumber *question_id = item[@"id"];
    
    QuestionLang *questionLangModel = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionLang" inManagedObjectContext:context];
    questionLangModel.question_id = question_id.intValue;
    questionLangModel.text = item[@"text"];
    questionLangModel.answer1 = item[@"answer1"];
    questionLangModel.answer2 = item[@"answer2"];
    questionLangModel.answer3 = item[@"answer3"];
    questionLangModel.answer4 = item[@"answer4"];
    questionLangModel.correct_answer = item[@"correct_answer"];
    
    NSNumber *questionModelId = item[@"question"];
    QuestionModel *questionModel = [QuestionModelService getQuestionModelByID: questionModelId.intValue];
    questionLangModel.question = questionModel;
    
    NSNumber *languageId = item[@"language"];
    Language *languageModel = [LanguageService getLanguageByID:languageId.intValue];
    questionLangModel.language = languageModel;
    
    [context save:nil];
    
    return questionLangModel;
}

+(QuestionLang *)updateQuestionModel:(NSDictionary *)item {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    NSNumber *question_id = item[@"id"];
    
    QuestionLang *questionModel = [QuestionLangService getQuestionById:question_id.intValue];
    questionModel.text = item[@"text"];
    questionModel.answer1 = item[@"answer1"];
    questionModel.answer2 = item[@"answer2"];
    questionModel.answer3 = item[@"answer3"];
    questionModel.answer4 = item[@"answer4"];
    questionModel.correct_answer = item[@"correct_answer"];
    questionModel.used = false;
    
    [context save:nil];
    
    return questionModel;
}

+(NSInteger)randomIndex:(NSInteger)arrayCount {
    return arc4random() % arrayCount;
}

@end
