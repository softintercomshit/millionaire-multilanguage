//
//  GameKitHelper.m
//  MonkeyJump
//
//  Created by SkeletoN on 2/26/13.
//
//

#import "GameKitHelper.h"
#import "AppSpecificValues.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
    
}
@end

@implementation GameKitHelper

#pragma mark Singleton stuff
+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
    {
        __weak GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
        
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
        {
            [self setLastError:error];
            
            if (localPlayer.authenticated)
            {
                _gameCenterFeaturesEnabled = YES;
            }
            else if(viewController)
            {
                [self presentViewController:viewController];
            }
            else
            {
                _gameCenterFeaturesEnabled = NO;
            }
        };
//        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
//        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
//            if (viewController != nil)
//            {
//                [self showAuthenticationDialogWhenReasonable: viewController];
//                 }
//                 else if (localPlayer.isAuthenticated)
//                 {
//                     [self authenticatedPlayer: localPlayer];
//                 }
//                 else
//                 {
//                     [self disableGameCenter];
//                 }
//                 };
    }
}

-(void)showAuthenticationDialogWhenReasonable:(UIViewController *)controller
{
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
}

-(void)authenticatedPlayer:(GKLocalPlayer *)player
{
    _gameCenterFeaturesEnabled = YES;
    player = [GKLocalPlayer localPlayer];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
}

-(void)disableGameCenter
{
    _gameCenterFeaturesEnabled = NO;
}


#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}


-(void) submitScore:(int64_t)score
           category:(NSString*)category {
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        NSLog(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if ([_delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [_delegate onScoresSubmitted:success];
         }
     }];
}

@end
