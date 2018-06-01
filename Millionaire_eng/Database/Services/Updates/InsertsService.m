#import "InsertsService.h"
#import "QuestionModelService.h"
#import "QuestionLangService.h"
#import "AccessLayer.h"

@implementation InsertsService

+(void)insertQuestions:(NSDictionary *)data {
    if (data) {
        NSArray *question_models = data[@"question_model"];
        NSArray *question_lang_models = data[@"question_lang_model"];
        
        if (question_models.count) {
            [self insertQuestionModelEntities:question_models];
        }
        
        if (question_lang_models.count) {
            [self insertQuestionLangModelEntities:question_lang_models];
        }
    }
}

+(void)insertQuestionModelEntities:(NSArray *)question_models {
    for (NSDictionary<NSString*, id> *item in question_models) {
        [QuestionModelService createQuestionModel:item];
    }
}

+(void)insertQuestionLangModelEntities:(NSArray *)question_lang_models {
    for (NSDictionary<NSString*, id> *item in question_lang_models) {
        [QuestionLangService createQuestionModel:item];
    }
}
@end
