#import "AppDelegate.h"
#import <LocalNotification/LocalNotification.h>
#import "SICAds.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Initialpopulate.h"

@implementation AppDelegate

@synthesize _traveller = traveller;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    [Initialpopulate startPopulate];
    
    // add fake records for testing
    /*
    traveller = [DataTraveller new];
    traveller._score = 1000000;
    for (int i = 0; i<50; i++) {
        [traveller addRecordWithUserName:@"Ivan"];
    }
     */
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    
    [[LocalNotification sharedNotification] cancelAllNotifications];
    
    NSArray *NotificationMesages = @[@"MESSAGE1".localized,
                                     @"MESSAGE2".localized,
                                     @"MESSAGE3".localized,
                                     @"MESSAGE4".localized,
                                     @"MESSAGE5".localized,
                                     @"MESSAGE1".localized,
                                     @"MESSAGE2".localized,
                                     @"MESSAGE3".localized,
                                     @"MESSAGE4".localized,
                                     @"MESSAGE5".localized];
    
    [[LocalNotification sharedNotification] registerNotification:NotificationMesages forDate:[NSDate dateWithTimeIntervalSinceNow:604800] withDelay:604800];
    
    [self setRootController];
    
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    self.isShowInterstitial = NO;
    
    [RestClient sendStatistics];
    
    return YES;
}

-(void) setRootController {
    NSString *storyboardName = isIpad ? @"MainStoryboard_iPad" : @"MainStoryboard_iPhone";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController* rootController = [storyboard instantiateInitialViewController];
//    rootController = [storyboard instantiateViewControllerWithIdentifier:@"WinGameViewController"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    [self sendToken: deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"Push Notification Description %@", [userInfo description]);
}

- (void) sendToken: (NSData*) DeviceToken
{
    NSString *strUrl = [NSString stringWithFormat:@"http://m.zemralab.com/api/%@/push",[[NSBundle mainBundle] bundleIdentifier]];
    
    NSString *myRequestString = [NSString stringWithFormat :@"%@", DeviceToken];
    NSString * newToken  = [myRequestString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    newToken = [newToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSDictionary *params = [NSDictionary dictionaryWithObject:newToken forKey:@"token"];
    
    [RestClient post:strUrl params:params onSucces:^(id result) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newToken forKey:@"DeviceTokenKey"];
        [defaults synchronize];
    } onFail:^(NSError *error) {
        
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [SICAds show];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [RestClient appCheck:nil];
}

@end
