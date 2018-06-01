#import "UpdatesService.h"
#import "DifficultyService.h"
#import "QuestionLangService.h"
#import "QuestionModelService.h"
#import "LanguageService.h"
#import "AccessLayer.h"

@implementation UpdatesService

+(void)updatesQuestions:(NSDictionary *)data {
    if (data) {
        NSArray *question_model_ids = data[@"question_model"];
        NSArray *question_lang_model_ids = data[@"question_lang_model"];
        
        if (question_model_ids.count) {
            [self updateQuestionModelEntities:question_model_ids];
        }
        
        if (question_lang_model_ids.count) {
            [self updateQuestionLangModelEntities:question_lang_model_ids];
        }
    }
}

+(void)updateQuestionModelEntities:(NSArray *)question_models {
    for (NSDictionary<NSString*, id> *item in question_models) {
        [QuestionModelService updateQuestionModel:item];
    }
}

+(void)updateQuestionLangModelEntities:(NSArray *)question_lang_models {
    for (NSDictionary<NSString*, id> *item in question_lang_models) {
        [QuestionLangService updateQuestionModel:item];
    }
}
@end
