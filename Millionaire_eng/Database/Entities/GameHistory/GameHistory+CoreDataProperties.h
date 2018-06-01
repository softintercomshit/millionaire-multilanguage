#import "GameHistory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GameHistory (CoreDataProperties)

+ (NSFetchRequest<GameHistory *> *)fetchRequest;

@property (nonatomic) int32_t question;
@property (nonatomic) int32_t difficulty;
@property (nullable, nonatomic, copy) NSString *answer;
@property (nullable, nonatomic, copy) NSString *game_play_id;
@property (nonatomic) double datetime;

@end

NS_ASSUME_NONNULL_END
