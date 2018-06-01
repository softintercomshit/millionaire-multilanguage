#import "GameHistoryService.h"
#import "AccessLayer.h"


@implementation GameHistoryService

+(GameHistory *)createEntityFromDict:(NSDictionary *)data {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    GameHistory *model = [NSEntityDescription insertNewObjectForEntityForName:@"GameHistory" inManagedObjectContext:context];
    model.answer = data[@"answer"];
    model.difficulty = [data[@"difficulty"] intValue];
    model.game_play_id = data[@"game_play_id"];
    model.question = [data[@"question"] intValue];
    model.datetime = [data[@"datetime"] doubleValue];
    
    [context save:nil];
    
    return model;
}

+(void)clearHistory {
    NSManagedObjectContext *context = [[AccessLayer shared] managedObjectContext];
    
    NSFetchRequest<GameHistory*> *formatRequest = [GameHistory fetchRequest];
    NSArray<GameHistory*> *objects = [context executeFetchRequest:formatRequest error:nil];
    
    for (GameHistory *gameHistory in objects) {
        [context deleteObject:gameHistory];
    }
    
    [context save:nil];
}

@end
