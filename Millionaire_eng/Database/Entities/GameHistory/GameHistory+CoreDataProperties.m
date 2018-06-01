#import "GameHistory+CoreDataProperties.h"

@implementation GameHistory (CoreDataProperties)

+ (NSFetchRequest<GameHistory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GameHistory"];
}

@dynamic question;
@dynamic difficulty;
@dynamic answer;
@dynamic game_play_id;
@dynamic datetime;

@end
