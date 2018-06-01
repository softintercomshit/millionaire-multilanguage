#import "GameHistory+CoreDataClass.h"

@interface GameHistory (Serializer)

@property(strong, nonatomic, readonly) NSDictionary *toDict;

@end
