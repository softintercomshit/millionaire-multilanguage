#import "Difficulty+CoreDataProperties.h"

@implementation Difficulty (CoreDataProperties)

+ (NSFetchRequest<Difficulty *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Difficulty"];
}

@dynamic difficulty_id;
@dynamic level;
@dynamic remuneration;

@end
