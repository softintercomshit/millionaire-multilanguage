#import <UIKit/UIKit.h>
#import "DataTraveller.h"
#import "AppDelegate.h"
#import "UIView+Animation.h"
#import "CustomView.h"
#import "MBProgressHUD.h"
#import "GameViewController.h"

@class AVAudioPlayer;
@interface GameOverViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate, MBProgressHUDDelegate>
{
    AVAudioPlayer* audioPlayer2;
    MBProgressHUD *HUD;
    IBOutletCollection(UIButton) NSArray *Report_btns;
    IBOutlet UIButton *Report_btn;
}
@property (retain, nonatomic) IBOutlet UITextField *tv_name;
@property (retain, nonatomic) IBOutlet UIButton *bt_save;
@property (retain, nonatomic) IBOutlet UIButton *bt_goMain;
@property (retain, nonatomic) IBOutlet UILabel *lb_score;
@property(nonatomic,assign) id<UITextViewDelegate> delegate;
@property (retain, nonatomic) DataTraveller* _traveller;
@property (retain, nonatomic) IBOutlet UILabel *lb_question;
@property (retain, nonatomic) IBOutlet UIView *report_view;


- (IBAction)addRecord:(id)sender;
- (IBAction)nameEnterDone:(id)sender;
- (IBAction)report_btn:(id)sender;
- (IBAction)send_report:(id)sender;


@end
