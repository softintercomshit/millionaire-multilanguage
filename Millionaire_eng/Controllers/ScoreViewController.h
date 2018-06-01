#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ScoreTableCell.h"
#import "CustomView.h"
#import "DataTraveller.h"
#import "UIView+Animation.h"
#import "AppSpecificValues.h"
#import "GameKitHelper.h"
#import "MainViewController.h"

@class  AVAudioPlayer;

@interface ScoreViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, GKLeaderboardViewControllerDelegate, GKGameCenterControllerDelegate>
{
    NSMutableArray *storage;
}
@property (retain, nonatomic) IBOutlet UITableView *scoreTable;

- (IBAction)goto_GameCenterLeaderboards:(id)sender;

@end
