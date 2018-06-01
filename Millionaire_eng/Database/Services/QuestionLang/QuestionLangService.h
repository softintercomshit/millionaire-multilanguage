#import <Foundation/Foundation.h>
#import "QuestionLang+CoreDataClass.h"

@interface QuestionLangService : NSObject

+(QuestionLang *)getQuestionForDifficulty:(int)level;
+(QuestionLang *)getQuestionById:(int)questionId;
+(QuestionLang *)createQuestionModel:(NSDictionary *)item;
+(QuestionLang *)updateQuestionModel:(NSDictionary *)item;

@end
