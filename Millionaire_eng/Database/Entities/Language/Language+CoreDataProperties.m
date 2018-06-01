#import "Language+CoreDataProperties.h"

@implementation Language (CoreDataProperties)

+ (NSFetchRequest<Language *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Language"];
}

@dynamic lang_id;
@dynamic name;

@end
