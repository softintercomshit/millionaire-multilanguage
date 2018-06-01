#import "QuestionModel+CoreDataProperties.h"

@implementation QuestionModel (CoreDataProperties)

+ (NSFetchRequest<QuestionModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"QuestionModel"];
}

@dynamic question_id;
@dynamic label;
@dynamic difficulty;

@end
