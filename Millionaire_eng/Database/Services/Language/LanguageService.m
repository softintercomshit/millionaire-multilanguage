#import "LanguageService.h"
#import "AccessLayer.h"

@implementation LanguageService

+(Language *)getLanguageByID:(int)lang_id {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<Language*> *formatRequest = [Language fetchRequest];
    formatRequest.predicate = [NSPredicate predicateWithFormat:@"lang_id == %d", lang_id];
    Language *object = [context executeFetchRequest:formatRequest error:nil].firstObject;
    
    return object;
}

+(Language *)getLanguageByName:(NSString *)name {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    NSFetchRequest<Language*> *formatRequest = [Language fetchRequest];
    formatRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    Language *object = [context executeFetchRequest:formatRequest error:nil].firstObject;
    
    return object;
}

@end
