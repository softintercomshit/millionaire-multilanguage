#import "GameHistory+Serializer.h"

@implementation GameHistory (Serializer)

-(NSDictionary *)toDict {
    NSDictionary *result = @{@"answer": self.answer,
                             @"difficulty": @(self.difficulty),
                             @"game_play_id": self.game_play_id,
                             @"question": @(self.question),
                             @"datetime": @(self.datetime)
                             };
    
    return result;
}

@end
