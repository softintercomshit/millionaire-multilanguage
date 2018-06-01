#import "Language+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Language (CoreDataProperties)

+ (NSFetchRequest<Language *> *)fetchRequest;

@property (nonatomic) int32_t lang_id;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
