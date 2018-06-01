#import "GameOverViewController.h"
#import "SICAds.h"

@implementation GameOverViewController{
    __weak IBOutlet UIView *mainConteiner;
    __weak IBOutlet UIImageView *logoImageView;
    KeyboardHandler *keyboardHandler;
}

@synthesize _traveller = traveller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        if(!isIpad){
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self.view setOrigin:CGPointMake(0, 0)];
                             }
                             completion:^(BOOL finished){
                             }];
        }
    }
    NSUInteger newLength = [textField.text length] - range.length;
    
    if(string.length > 0)
        [_bt_save setEnabled:(newLength + string.length > 0) ? YES : NO];
    else
        [_bt_save setEnabled:(newLength - string.length > 0) ? YES : NO];
    
    return (newLength > 14) ? NO : YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGRect frame = [textField convertRect:textField.bounds toView:self.view];
    keyboardHandler.textFieldFrame = frame;
    
    return true;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RestClient sendStatistics];
    
    keyboardHandler = [KeyboardHandler new];
    [keyboardHandler startObservingKeyboardChangesFor:self.view];
    
    [mainConteiner addToSafeArea];
    [SICAds show];
    
    [self.bt_goMain setExclusiveTouch:YES];
    [self.bt_save setExclusiveTouch:YES];
    [Report_btn setExclusiveTouch:YES];
    for(int i = 0; i < Report_btns.count; i++){
        [[Report_btns objectAtIndex:i] setExclusiveTouch:YES];
    }
    if([traveller _score] > 0) [self send_score];
    
    _tv_name.delegate = self;
    _lb_question.text = traveller.questionModel.text;
    NSLog(@"score: %i",[traveller _score]);
    [_lb_score setText:[NSString stringWithFormat:@"%i",[traveller _score]]];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Lose.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        NSLog(@"ERROR: %@",[error description]);
        audioPlayer2.numberOfLoops = 0;
        [audioPlayer2 play];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupButtonsIcons];
    [logoImageView setImageWithName:isIpad ? @"ipad_logo.png".localized : @"logo.png".localized];
}

-(void)setupButtonsIcons {
    [_bt_save setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
    
    [_bt_goMain setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    CGRect frame = [_tv_name convertRect:_tv_name.bounds toView:self.view];
    keyboardHandler.textFieldFrame = frame;
}

-(void) send_score{
    NSArray *arr = [[NSArray alloc] initWithObjects:[GKLocalPlayer localPlayer].playerID, nil];
    GKLeaderboard *board = [[GKLeaderboard alloc] initWithPlayerIDs:arr];
    if(board != nil) {
        board.timeScope = GKLeaderboardTimeScopeAllTime;
        board.range = NSMakeRange(1, 1);
        board.category = kHighScoreLeaderboardID;
        [board loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error != nil) {
                // handle the error.
                NSLog(@"Error retrieving score.", nil);
            }
            if (scores != nil) {
                [[GameKitHelper sharedGameKitHelper] submitScore:(int64_t)([traveller _score])+board.localPlayerScore.value category:kHighScoreLeaderboardID];
            } else  [[GameKitHelper sharedGameKitHelper] submitScore:(int64_t)([traveller _score]) category:kHighScoreLeaderboardID];
        }];
    }
}

- (void)viewDidUnload
{
    [self setBt_save:nil];
    [self setTv_name:nil];
    [self setLb_score:nil];
    [self setBt_goMain:nil];
    [super viewDidUnload];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"])
    {
        [audioPlayer2 stop];
        audioPlayer2 = nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Input Methods

- (IBAction)addRecord:(id)sender
{
    UIButton* bt = (UIButton*) sender;
    if([bt tag] == 1) //save
    {
        [traveller addRecordWithUserName:_tv_name.text];
        
    }
    [_tv_name resignFirstResponder];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)nameEnterDone:(id)sender
{
    [sender resignFirstResponder];
    [_bt_save setEnabled:([_tv_name text].length != 0) ? YES : NO];
}

- (IBAction)report_btn:(id)sender {
    [_tv_name resignFirstResponder];
    [self.report_view setHidden:NO];
}

- (IBAction)send_report:(id)sender {
    UIButton* bt = (UIButton*) sender;
    if ([bt tag] != 0) {
        [self send_report_request:[bt tag]];
    }
    [self.report_view setHidden:YES];
}

-(void) send_report_request:(int)request_id{
    NSDictionary *params = @{@"question": @(traveller.questionModel.question_id), @"bug_type": @(request_id), @"device_token": [OpenUDID value]};
    
    [RestClient post:BASE_URL(@"api/bugreport/") params:params onSucces:^(id result) {
        HUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"THANKS".localized;
        HUD.delegate = self;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    } onFail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
