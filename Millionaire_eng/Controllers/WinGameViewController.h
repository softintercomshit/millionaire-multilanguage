#import <UIKit/UIKit.h>
#import "DataTraveller.h"
#import "AppDelegate.h"
#import "UIView+Animation.h"
#import "CustomView.h"
#import "GameViewController.h"

@class AVAudioPlayer;
@interface WinGameViewController : UIViewController<UIActionSheetDelegate, UITextFieldDelegate>
{
    AVAudioPlayer* audioPlayer2;
}
@property (retain, nonatomic) IBOutlet UITextField *winner_name;
@property (retain, nonatomic) IBOutlet UIButton *save;
@property (retain, nonatomic) IBOutlet UIButton *goMain;
@property (retain, nonatomic) DataTraveller* _traveller;
@property(nonatomic,assign) id<UITextViewDelegate> delegate;

- (IBAction)addRecord:(id)sender;
- (IBAction)nameEnterDone:(id)sender;

@end
