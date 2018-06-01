//
//  GameKitHelper.h
//  MonkeyJump
//
//  Created by SkeletoN on 2/26/13.
//
//

//   Include the GameKit framework
#import <GameKit/GameKit.h>
#import<UIKit/UIKit.h>


@class GKLeaderboard, GKPlayer;
//   Protocol to notify external
//   objects when Game Center events occur or
//   when Game Center async tasks are completed
@protocol GameKitHelperProtocol<NSObject>
-(void) onScoresSubmitted:(bool)success;
@end


@interface GameKitHelper : NSObject<GKGameCenterControllerDelegate>

@property (nonatomic, assign)
id<GameKitHelperProtocol> delegate;

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;

// Scores
-(void) submitScore:(int64_t)score
           category:(NSString*)category;
@end