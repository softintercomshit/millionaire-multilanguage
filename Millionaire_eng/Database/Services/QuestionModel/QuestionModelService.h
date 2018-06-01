#import <Foundation/Foundation.h>
#import "QuestionModel+CoreDataClass.h"

@interface QuestionModelService : NSObject

+(QuestionModel *)getQuestionModelByID:(int)question_id;
+(QuestionModel *)createQuestionModel:(NSDictionary *)item;
+(QuestionModel *)updateQuestionModel:(NSDictionary *)item;

@end
