#import "QuestionLang+CoreDataProperties.h"

@implementation QuestionLang (CoreDataProperties)

+ (NSFetchRequest<QuestionLang *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"QuestionLang"];
}

@dynamic answer1;
@dynamic answer2;
@dynamic answer3;
@dynamic answer4;
@dynamic correct_answer;
@dynamic question_id;
@dynamic text;
@dynamic used;
@dynamic language;
@dynamic question;

@end
