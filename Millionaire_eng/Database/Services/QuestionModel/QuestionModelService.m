#import "QuestionModelService.h"
#import "AccessLayer.h"
#import "DifficultyService.h"

@implementation QuestionModelService

+(QuestionModel *)getQuestionModelByID:(int)question_id {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<QuestionModel*> *formatRequest = [QuestionModel fetchRequest];
    formatRequest.predicate = [NSPredicate predicateWithFormat:@"question_id == %d", question_id];
    QuestionModel *object = [context executeFetchRequest:formatRequest error:nil].firstObject;
    
    return object;
}

+(QuestionModel *)createQuestionModel:(NSDictionary *)item {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    NSNumber *question_id = item[@"id"];
    NSNumber *difficulty = item[@"difficulty"];
    NSString *label = item[@"label"];
    
    QuestionModel *questionModel = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionModel" inManagedObjectContext:context];
    questionModel.label = label;
    questionModel.question_id = question_id.intValue;
    
    Difficulty *difficulty_model = [DifficultyService getDifficultyByLevel:difficulty.intValue];
    questionModel.difficulty = difficulty_model;
    
    [context save:nil];
    
    return questionModel;
}

+(QuestionModel *)updateQuestionModel:(NSDictionary *)item {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    NSNumber *question_id = item[@"id"];
    NSNumber *difficulty = item[@"difficulty"];
    
    QuestionModel *questionModel = [QuestionModelService getQuestionModelByID:question_id.intValue];
    questionModel.label = item[@"label"];
    
    Difficulty *difficulty_model = [DifficultyService getDifficultyByLevel:difficulty.intValue];
    questionModel.difficulty = difficulty_model;
    
    [context save:nil];
    
    return questionModel;
}

@end
