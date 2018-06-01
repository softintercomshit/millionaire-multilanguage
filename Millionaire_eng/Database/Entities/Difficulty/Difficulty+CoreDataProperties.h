#import "Difficulty+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Difficulty (CoreDataProperties)

+ (NSFetchRequest<Difficulty *> *)fetchRequest;

@property (nonatomic) int32_t difficulty_id;
@property (nonatomic) int32_t level;
@property (nonatomic) int32_t remuneration;

@end

NS_ASSUME_NONNULL_END
