#import <UIKit/UIKit.h>
#import "DataTraveller.h"
#import "GameKitHelper.h"
#import "AppSpecificValues.h"
#import "JSONKit.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    DataTraveller* traveller;
    @private NSString* db_file_path;
}
@property (readonly,nonatomic) NSString *info;
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) DataTraveller* _traveller;
@property(nonatomic, readonly) NSString *interstitialAdUnitID;
@property(nonatomic, assign) BOOL isShowInterstitial;

-(void) setRootController;

@end
