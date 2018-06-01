//
//  GameViewController.h
//  Millionaire_rus
//
//  Created by SkeletoN on 12/21/12.
//  Copyright (c) 2012 SkeletoN. All rights reserved.
//
#pragma mark -
#pragma mark Class Constants

#define ANSWER_ONE   1
#define ANSWER_TWO   2
#define ANSWER_THREE 3
#define ANSWER_FOUR  4

#define HELP_50_50 5
#define HELP_CROWD 6
#define HELP_NEXT  7

#define BTS_HELP_TRANSLATE_RATE 0.15

//buttons animation states:
#define BT_ANSWER_IN 0
#define BT_ANSWER_TRANS 1
#define BT_ANSWER_OUT 2



#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DataTraveller.h"
#import "UIView+Animation.h"
#import "CustomView.h"
#import "GameOverViewController.h"
#import "WinGameViewController.h"
#import <AVFoundation/AVFoundation.h>
#include "OpenUDID.h"
#import <unistd.h>
#import "MBProgressHUD.h"
#import "AppSpecificValues.h"
#import "GameKitHelper.h"
#import "AudienceView.h"

struct ArrayInteger
{
    int* m;
    int length;
};

@interface GameViewController : UIViewController<UIActionSheetDelegate, MBProgressHUDDelegate>
#pragma mark - Class Vars
{
    BOOL isAnimationStarted;
    int buttonsOrigin[4];
    BOOL isStatusVisible;
    NSMutableArray *mm;
    DataTraveller* traveller;
@private int btAnswerStatus[4];
@private BOOL confirmViewCalled;//block multiple confirmView call
@private BOOL forgotCrowdHelp;
@private __block int duration;
@private id c;
    MBProgressHUD *HUD;
    //INNER USE:
@private BOOL helpState;
@private BOOL isNextQuestion;
    AVAudioPlayer *audioPlayer;
@private NSURL *url;
    int tmpTime;
    NSTimer *timer;
    IBOutlet UILabel *timerLb;
@private int visible_answers;
    IBOutlet UIButton *soundBtn;
    IBOutlet UIButton *Report_btn;
    IBOutlet UIButton *OKStatus_btn;
    IBOutlet UIButton *Exit_btn;
    IBOutlet UIImageView *timerImage;
@private NSString* db_file_path;
    IBOutletCollection(UIButton) NSArray *AnswerConfirm_btn;
    IBOutletCollection(UIButton) NSArray *HelpConfirm_btn;
    IBOutletCollection(UIButton) NSArray *Report_btns;
    IBOutletCollection(UIButton) NSArray *ExitConfirm_btn;

    IBOutlet UILabel *AnswConfirmLabel;
    IBOutlet UIButton *AnswerConfirmYes;
    IBOutlet UIButton *AnswerConfirmNo;
    IBOutlet UIButton *AnswerConfirmWalk;
    IBOutlet UILabel *GoMainLabel;
    IBOutlet UIButton *GoMainNo;
    IBOutlet UIButton *GoMainYes;
    IBOutlet UIButton *ConfirmHelpNo;
    IBOutlet UIButton *ConfirmHelpYes;
    
}

@property (strong, nonatomic) IBOutlet UILabel *help_label;
@property(nonatomic,retain) AVAudioPlayer *audioPlayer;
@property(nonatomic,retain) AVAudioPlayer *audioPlayer2;
@property (strong, nonatomic) IBOutlet UIButton *crowd;

@property (retain, nonatomic) IBOutlet UILabel *lbscore;
@property (retain, nonatomic) IBOutlet UILabel *lb_question_;
@property (strong, nonatomic) IBOutlet UILabel *lb_request_question;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *bt_answers;
//@property (strong, nonatomic) IBOutlet UIButton *_bt_answers;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *AudienceLB;
@property (retain, nonatomic) IBOutletCollection(AudienceView) NSArray *AudienceIV;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *bts_help;
@property (readonly, retain, nonatomic) DataTraveller* _traveller;
@property (strong, nonatomic) IBOutlet UIImageView *StatusView;
@property (strong, nonatomic) IBOutlet UIView *report_view;


- (IBAction)confirmAnswer:(id)sender;
- (IBAction)chooseAnswer:(id)sender;
- (IBAction)useHelp:(id)sender;
- (IBAction)audienceDismiss:(id)sender;
- (IBAction)helpConfirm:(id)sender;
- (IBAction)helpConfirmBts:(id)sender;
- (IBAction)leaveGame:(id)sender;
- (IBAction)exitViewBts:(id)sender;
- (IBAction)viewStatus:(id)sender;
- (IBAction)statusDismiss:(id)sender;
- (IBAction)soundButtonPressed:(id)sender;
- (IBAction)report_btn:(id)sender;
- (IBAction)send_report:(id)sender;



#pragma mark - Data Manipulations
- (void)DecisionIsMade;
- (void)timerMethod:(NSTimer*)_timer;
- (void) stopMusicAndTimer;
- (void) IsTrueOrNot:(UIButton*)btn;
- (void) FailGame;
- (void) setQuestionData;
- (void) use50_50;
- (NSMutableArray*) generateAudienceHelpDataForTwoAnswers: (BOOL) forTwo;

#pragma mark - General Methods

+(id) getElementFromArray: (NSArray*) arr withTag: (int) tag;

@end

