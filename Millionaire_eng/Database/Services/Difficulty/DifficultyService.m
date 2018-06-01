#import "DifficultyService.h"
#import "AccessLayer.h"

@implementation DifficultyService

+(Difficulty *)getDifficultyByLevel:(int)level {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<Difficulty*> *formatRequest = [Difficulty fetchRequest];
    formatRequest.predicate = [NSPredicate predicateWithFormat:@"difficulty_id == %d", level];
    Difficulty *object = [context executeFetchRequest:formatRequest error:nil].firstObject;
    
    return object;
}

@end
