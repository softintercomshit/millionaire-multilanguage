#import "QuestionLang+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface QuestionLang (CoreDataProperties)

+ (NSFetchRequest<QuestionLang *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *answer1;
@property (nullable, nonatomic, copy) NSString *answer2;
@property (nullable, nonatomic, copy) NSString *answer3;
@property (nullable, nonatomic, copy) NSString *answer4;
@property (nullable, nonatomic, copy) NSString *correct_answer;
@property (nonatomic) int32_t question_id;
@property (nullable, nonatomic, copy) NSString *text;
@property (nonatomic) BOOL used;
@property (nullable, nonatomic, retain) Language *language;
@property (nullable, nonatomic, retain) QuestionModel *question;

@end

NS_ASSUME_NONNULL_END
