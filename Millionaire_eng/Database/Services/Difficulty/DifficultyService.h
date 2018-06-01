#import <Foundation/Foundation.h>
#import "Difficulty+CoreDataClass.h"

@interface DifficultyService : NSObject

+(Difficulty *)getDifficultyByLevel:(int)level;

@end
