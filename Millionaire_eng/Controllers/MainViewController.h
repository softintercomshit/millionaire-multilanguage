#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Animation.h"
#import "CustomView.h"
#import "DataTraveller.h"
#import "MBProgressHUD.h"
#import "HelpViewController.h"
#import "ScoreViewController.h"
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController < MBProgressHUDDelegate, MFMailComposeViewControllerDelegate >
{
    MBProgressHUD *HUD;
    AVAudioPlayer *audioPlayer;
    IBOutlet UIButton *soundBtn;
    @private NSString* info;
    int dbvesrion;
//    GADInterstitial *interstitial_;
    DataTraveller* traveller;
@private NSString* db_file_path;
    IBOutlet UIButton *play_btn;
    IBOutlet UIButton *HowToPlay_btn;
    IBOutlet UIButton *score_btn;
    IBOutlet UIButton *Update_btn;
    IBOutlet UIButton *Download_btn;
    IBOutlet UIButton *Cancel_btn;
    IBOutlet UIButton *Full_btn;
    
    IBOutlet UILabel *timer_text;
    IBOutlet UILabel *timer_label;
    IBOutlet UIButton *buy_button;
    IBOutlet UIButton *wait_button;
    IBOutlet UIButton *watch_ad_button;
    NSTimer *timer;
    
    IBOutlet UIButton *buttonGallery;
}
@property (retain, nonatomic) DataTraveller* _traveller;

@property(nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UIButton *database_update_btn;
@property (strong, nonatomic) IBOutlet UIView *database_update_view;
@property (strong, nonatomic) IBOutlet UIView *database_update_subview;
@property (strong, nonatomic) IBOutlet UITextView *database_update_textView;
@property (strong, nonatomic) IBOutlet UIButton *lang_btn;


- (IBAction)ShowInterstitial:(UIButton *)sender;
- (IBAction)WaitAction:(UIButton *)sender;
- (IBAction)PlayGame:(UIButton *)sender;
- (IBAction)sendSuportAction:(UIButton *)sender;
- (IBAction)ShowSuportView:(UIButton *)sender;
 
- (IBAction)soundButtonPressed:(id)sender;
- (IBAction)Update:(id)sender;
- (IBAction)Update_database:(id)sender;
- (IBAction)Upgrade_to_paid:(id)sender;
- (IBAction)change_language:(id)sender;
- (IBAction)set_language:(id)sender;
- (IBAction)closeLanguage:(id)sender;

- (void)checkUpdates;

@end
