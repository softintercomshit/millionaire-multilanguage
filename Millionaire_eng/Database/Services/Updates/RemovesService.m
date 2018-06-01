#import "RemovesService.h"
#import "QuestionModel+CoreDataClass.h"
#import "QuestionLang+CoreDataClass.h"
#import "AccessLayer.h"

@implementation RemovesService

+(void)removeQuestions:(NSDictionary *)data {
    if (data) {
        NSArray<NSNumber *> *question_model_ids = data[@"question_model_ids"];
        NSArray<NSNumber *> *question_lang_model_ids = data[@"question_lang_model_ids"];
        
        if (question_model_ids.count) {
            [self deleteQuestionModelEntities:question_model_ids];
        }
        
        if (question_lang_model_ids.count) {
            [self deleteQuestionLangModelEntities:question_lang_model_ids];
        }
    }
}

+(void)deleteQuestionModelEntities:(NSArray<NSNumber *> *)ids {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<QuestionModel*> *formatRequest = [QuestionModel fetchRequest];
    formatRequest.predicate = [NSPredicate predicateWithFormat:@"question_id in %@", ids];
    NSArray<QuestionModel*> *questions = [context executeFetchRequest:formatRequest error:nil];
    
    for (QuestionModel *questionModel in questions) {
        [context deleteObject:questionModel];
    }
    
    [context save:nil];
}

+(void)deleteQuestionLangModelEntities:(NSArray<NSNumber *> *)ids {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<QuestionLang*> *formatRequest = [QuestionLang fetchRequest];
    formatRequest.predicate = [NSPredicate predicateWithFormat:@"id in %@", ids];
    NSArray<QuestionLang*> *questions = [context executeFetchRequest:formatRequest error:nil];
    
    for (QuestionLang *questionModel in questions) {
        [context deleteObject:questionModel];
    }
    
    [context save:nil];
}

@end
