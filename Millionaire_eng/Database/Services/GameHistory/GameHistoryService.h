#import <Foundation/Foundation.h>
#import "GameHistory+CoreDataClass.h"


@interface GameHistoryService : NSObject

+(GameHistory *)createEntityFromDict:(NSDictionary *)data;
+(void)clearHistory;

@end
