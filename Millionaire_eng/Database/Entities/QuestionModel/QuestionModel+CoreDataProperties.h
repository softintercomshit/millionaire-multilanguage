#import "QuestionModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface QuestionModel (CoreDataProperties)

+ (NSFetchRequest<QuestionModel *> *)fetchRequest;

@property (nonatomic) int32_t question_id;
@property (nullable, nonatomic, copy) NSString *label;
@property (nullable, nonatomic, retain) Difficulty *difficulty;

@end

NS_ASSUME_NONNULL_END
