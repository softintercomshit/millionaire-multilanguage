#import "GameViewController.h"
#import <LocalNotification/LocalNotification.h>
#import "KAProgressLabel.h"
#import "QuestionLang+CoreDataClass.h"
#import <CommonCrypto/CommonDigest.h>


@implementation GameViewController {
    __weak IBOutlet UIView *mainConteiner;
    __weak IBOutlet UIButton *audienceOKButton;
    IBOutletCollection(NSLayoutConstraint) NSArray *answerButtonCenterConstraints;
    __weak IBOutlet KAProgressLabel *timerCircle;
    __weak IBOutlet UIImageView *inputImageView;
    __weak IBOutlet UIImageView *logoImageView;
}

@synthesize audioPlayer,audioPlayer2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpTimerCircle];
    
    [mainConteiner addToSafeArea];
    
    [self SetExclusiveTouch];
    
    //INNER USE INITIALIZATION:
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    isAnimationStarted = NO;
    for(int i = 0; i < _bt_answers.count; i++) {
        buttonsOrigin[i] = (int)[[_bt_answers objectAtIndex:i] frame].origin.x;
    }
    confirmViewCalled = NO;
    helpState = YES;
    forgotCrowdHelp = NO;
    db_file_path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/icon.jpg"];
    traveller = [[DataTraveller alloc] initWithFilePath:db_file_path];
    [traveller reset];
    traveller.gamePlayId = [self gamePlayId];
    
    soundBtn.selected = [[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"];
    url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Round1.mp3", [[NSBundle mainBundle] resourcePath]]];
    if(![self.audioPlayer isPlaying]) {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
            NSError *error;
            AVAudioPlayer* audioPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            audioPlayerTmp.numberOfLoops = 0;
            
            self.audioPlayer = audioPlayerTmp;
            [self.audioPlayer play];
        }
    }
    [self setQuestionData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupButtonsIcons];
    [logoImageView setImageWithName:isIpad ? @"ipad_logo.png".localized : @"logo.png".localized];
}

-(NSString *)gamePlayId {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    traveller.timestamp = timestamp;
    NSString *uniqueId = [NSString stringWithFormat:@"%@%f", [OpenUDID value], timestamp];
    return [self md5:uniqueId];
}

-(NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

-(void)setupButtonsIcons {
    NSString *blackImageName = isIpad ? @"ipad_black_" : @"black_";
    NSString *orangeImageName = isIpad ? @"ipad_orange_" : @"orange_";
    
    for (UIButton *button in _bt_answers) {
        [button setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", blackImageName, button.tag] state:UIControlStateNormal];
        [button setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", orangeImageName, button.tag] state:UIControlStateHighlighted];
        [button setBackgroundImageWithName:@"plashka_select" state:UIControlStateSelected];
    }
}

-(void)setUpTimerCircle {
    timerCircle.roundedCornersWidth = isIpad ? 10 : 5;
    timerCircle.progressWidth = isIpad ? 10: 5;
    timerCircle.progressColor = [UIColor whiteColor];
    [timerCircle setStartDegree:0 timing:TPPropertyAnimationTimingEaseInEaseOut duration:0 delay:0];
    [timerCircle setEndDegree:360 timing:TPPropertyAnimationTimingEaseInEaseOut duration:0 delay:0];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    for (AudienceView *item in _AudienceIV) {
        [item willRotate];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    for (AudienceView *item in _AudienceIV) {
        [item didRotate];
    }
}

- (void)viewDidUnload
{
    [self setLb_question_:nil];
    [self setBt_answers:nil];
    [self setLbscore:nil];
    [self setAudienceLB:nil];
    [self setAudienceIV:nil];
    [self setStatusView:nil];
    timerImage = nil;
    [self setCrowd:nil];
    soundBtn = nil;
    [self setLb_request_question:nil];
    [self setReport_view:nil];
    [self setHelp_label:nil];
    Report_btn = nil;
    AnswerConfirm_btn = nil;
    HelpConfirm_btn = nil;
    OKStatus_btn = nil;
    Report_btns = nil;
    ExitConfirm_btn = nil;
    Exit_btn = nil;
    AnswConfirmLabel = nil;
    AnswerConfirmYes = nil;
    AnswerConfirmNo = nil;
    AnswerConfirmWalk = nil;
    GoMainLabel = nil;
    GoMainNo = nil;
    GoMainYes = nil;
    ConfirmHelpNo = nil;
    ConfirmHelpYes = nil;
    [super viewDidUnload];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UI Interactions

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"game_over"])
    {
        GameOverViewController *finish = segue.destinationViewController;
        finish._traveller = traveller;
    }
    if ([segue.identifier isEqualToString:@"win_game"])
    {
        WinGameViewController *win = segue.destinationViewController;
        win._traveller = traveller;
    }
    if([audioPlayer isPlaying])
    {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    
    [self lockGames];
}


- (IBAction)chooseAnswer:(id)sender
{
    if(helpState){
        helpState = NO;
        if(!confirmViewCalled)
        {
            self.view.userInteractionEnabled = NO;
            UIView* uiv;
            confirmViewCalled = YES;
            UIButton* bt = (UIButton*) sender;
            [traveller checkAnswer:bt.tag];
            if ([traveller _currentQuestionCount] < 6) {
                confirmViewCalled = NO;
                [self DecisionIsMade];
            } else {
                NSString *orangeImageName = isIpad ? @"ipad_orange_" : @"orange_";
                [bt setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", orangeImageName, bt.tag] state:UIControlStateNormal];
                
                uiv = (UIView*) [CustomView newCustomView:isIpad ? @"AnswerConfirm_ipad" : @"AnswerConfirm"  owner:self];
                
                [AnswerConfirmYes setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
                [AnswerConfirmYes setBackgroundImageWithName:@"button_white_click" state:UIControlStateHighlighted];
                
                [AnswerConfirmNo setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
                [AnswerConfirmNo setBackgroundImageWithName:@"button_white_click" state:UIControlStateHighlighted];
                
                [AnswerConfirmWalk setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
                [AnswerConfirmWalk setBackgroundImageWithName:@"button_white_click" state:UIControlStateHighlighted];
                
                [inputImageView setImageWithName:@"input"];
                
                [self.view addSubviewWithoutZoomInAnimation: uiv
                                                   duration:1.f
                                                      delay:0
                                                     option:UIViewAnimationOptionCurveEaseInOut
                                                      block:nil];
                AnswConfirmLabel.text = @"CONFIRM".localized;
                [AnswerConfirmYes setTitle:@"YES".localized forState:UIControlStateNormal];
                [AnswerConfirmNo setTitle:@"NO".localized forState:UIControlStateNormal];
                [AnswerConfirmWalk setTitle:@"WALK".localized forState:UIControlStateNormal];
                self.view.userInteractionEnabled = YES;
                for(int i = 0; i < AnswerConfirm_btn.count; i++){
                    [[AnswerConfirm_btn objectAtIndex:i] setExclusiveTouch:YES];
                }
            }
        }
    }
}

- (IBAction)useHelp:(id)sender
{
    UIView* uiv;
    UIButton* bt = (UIButton*) sender;
    [traveller setHelpAt:[bt tag] - 1 value:true];
    switch ([bt tag])
    {
        case HELP_50_50:
            [self use50_50];
            [bt setEnabled:NO];
            break;
        case HELP_CROWD:
        {
            duration = 0;
            uiv = (UIView*) [CustomView newCustomView:isIpad ? @"AudienceView_ipad" : @"AudienceView" owner:self];
            
            [audienceOKButton setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
            [audienceOKButton setBackgroundImageWithName:@"button_white_click" state:UIControlStateHighlighted];
            
            [uiv setCenter: CGPointMake([[UIScreen mainScreen] bounds].origin.x + [[UIScreen mainScreen] bounds].size.width/2,
                                        [[UIScreen mainScreen] bounds].origin.y + [[UIScreen mainScreen] bounds].size.height/2)];
            
            if (forgotCrowdHelp == NO) {
                mm = [self generateAudienceHelpDataForTwoAnswers:[traveller getHelpAt:4]];
                duration = 2;
            }
            
            __weak UIButton *audienceOKButtonWeak = audienceOKButton;
            __weak NSArray *weakAudienceIV = _AudienceIV;
            __weak NSMutableArray *weakMM = mm;
            
            [self.view addSubviewWithoutZoomInAnimation: uiv duration: 1.5f delay: 0 option: UIViewAnimationOptionCurveEaseInOut block:^(BOOL finished) {
//                [audienceOKButtonWeak setBackgroundImage:[UIImage appImageWithName:isIpad ? @"ipad_cell_white" : @"button_white"] forState:UIControlStateNormal];
//                [audienceOKButtonWeak setBackgroundImage:[UIImage appImageWithName:isIpad ? @"ipad_cell_orange" : @"button_white_click"] forState:UIControlStateHighlighted];
                
                if(finished) {
                    for(int i = 0; i < weakAudienceIV.count; i++) {
                        AudienceView* iv = weakAudienceIV[i];
                        float scaleValue = [weakMM[i] floatValue];
                        [iv animateWithPercents:scaleValue/100 duration:1];
                    }
                }
            }];

            forgotCrowdHelp = YES;
            [bt setSelected:YES];
        }
            break;
            
        case HELP_NEXT:
            [self callAnimButtons: NO delay:0];
            self.view.userInteractionEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self callAnimButtons:true delay:0];
            });
            [self animateQuestionChange];
            if (forgotCrowdHelp == YES)
            {
                [self.crowd setSelected:NO];
                [self.crowd setEnabled:NO];
            }
            [bt setEnabled:NO];
            break;
    }
}

- (IBAction)audienceDismiss:(id)sender
{
    helpState = YES;
    [[sender superview] removeWithZoomOutNoAnimation:1.5f delay: 0 option:UIViewAnimationOptionCurveEaseInOut];
}

- (IBAction)helpConfirm:(id)sender {
    helpState = YES;
    UIButton* bt = (UIButton*) sender;
    if([bt tag] == 1)//Yes
    {
        [self useHelp:c];
        [[[bt superview] superview] removeWithZoomOutNoAnimation:.0f delay:0 option:UIViewAnimationCurveEaseInOut];
    }
    if([bt tag] == 0)//No
    {
        [[[bt superview] superview] removeWithZoomOutNoAnimation:.75 delay:0 option:UIViewAnimationCurveEaseInOut];
    }
}

- (IBAction)helpConfirmBts:(id)sender {
    if(helpState){
        helpState = NO;
        if ([sender tag] == 6 && forgotCrowdHelp == YES) {
            [self useHelp:sender];
        }
        else{
            UIView* uiv = (UIView*) [CustomView newCustomView:isIpad ? @"HelpConfirm_ipad" : @"HelpConfirm" owner:self];
            [uiv setFrame:self.view.bounds];
            [self.view addSubviewWithoutZoomInAnimation:uiv
                                               duration:.0f
                                                  delay:0
                                                 option:UIViewAnimationCurveEaseInOut
                                                  block:nil];
            for(int i = 0; i < HelpConfirm_btn.count; i++){
                [[HelpConfirm_btn objectAtIndex:i] setExclusiveTouch:YES];
            }
            
            c = sender;
            [ConfirmHelpYes setTitle:@"YES".localized forState:UIControlStateNormal];
            [ConfirmHelpNo setTitle:@"NO".localized forState:UIControlStateNormal];
            switch ([sender tag]) {
                case 5:
                    _help_label.text = @"FIFTY".localized;
                    break;
                case 6:
                    _help_label.text = @"AUDIENCE".localized;
                    break;
                case 7:
                    _help_label.text = @"REPLACE".localized;
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (IBAction)confirmAnswer:(id)sender
{
    confirmViewCalled = NO;
    UIButton* bt = (UIButton*) sender;
    UIButton *btn = (UIButton*)[self.view viewWithTag:[traveller getTag]];
    switch ([bt tag])
    {
        case 1://YES
            [[[bt superview] superview] removeWithZoomOutNoAnimation: 0 delay: 0 option:UIViewAnimationOptionCurveEaseInOut];
            [self DecisionIsMade];
            break;
            
        case 0 ://NO
        {
            [[[bt superview] superview] removeWithZoomOutNoAnimation:.5f delay: 0 option:UIViewAnimationOptionCurveEaseInOut];
            
            NSString *blackImageName = isIpad ? @"ipad_black_" : @"black_";
            [btn setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", blackImageName, (long)[traveller getTag]] state:UIControlStateNormal];
        }
            break;
        case 2://Walk Away
        {
            [[[bt superview] superview] removeWithZoomOutNoAnimation:.5f delay: 0 option:UIViewAnimationOptionCurveEaseInOut];
            
            NSString *blackImageName = isIpad ? @"ipad_black_" : @"black_";
            [btn setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", blackImageName, (long)[traveller getTag]] state:UIControlStateNormal];
            
            [self stopMusicAndTimer];
            [self performSegueWithIdentifier:@"game_over" sender:self];
        }
            break;
    }
    helpState = YES;
}

- (IBAction)leaveGame:(id)sender
{
    if(helpState){
        helpState = NO;
        self.view.userInteractionEnabled = NO;
        UIView* uiv = (UIView*) [CustomView newCustomView:isIpad ? @"ExitView_ipad" : @"ExitView" owner:self];
        [uiv setFrame:self.view.bounds];
        [self.view addSubviewWithoutZoomInAnimation:uiv
                                           duration:.75
                                              delay:0
                                             option:UIViewAnimationCurveEaseInOut
                                              block:nil];
        for(int i = 0; i < ExitConfirm_btn.count; i++){
            [[ExitConfirm_btn objectAtIndex:i] setExclusiveTouch:YES];
        }
        GoMainLabel.text = @"MAIN".localized;
        [GoMainYes setTitle:@"YES".localized forState:UIControlStateNormal];
        [GoMainNo setTitle:@"NO".localized forState:UIControlStateNormal];
        [self performBlock:^{self.view.userInteractionEnabled = YES;} afterDelay:.1];
    }
}

- (IBAction)exitViewBts:(id)sender {
    UIButton* bt = (UIButton*) sender;
    if([bt tag] == 1)//Yes
    {
        [self stopMusicAndTimer];
        
        [self lockGames];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if([bt tag] == 0)//No
    {
        helpState = YES;
        [[[bt superview] superview] removeWithZoomOutNoAnimation:.75 delay:0 option:UIViewAnimationCurveEaseInOut];
    }
}

- (IBAction)viewStatus:(id)sender {
    if(helpState){
        helpState = NO;
        UIView *statusView = [CustomView newCustomView:isIpad ? @"StatusView_ipad" : @"StatusView" owner:self];
        
        [OKStatus_btn setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
        [OKStatus_btn setBackgroundImageWithName:@"button_white_click" state:UIControlStateHighlighted];
        
        [self.view addSubviewWithoutZoomInAnimation:statusView
                                           duration:.75
                                              delay:0
                                             option:UIViewAnimationCurveEaseInOut
                                              block:nil];

        isStatusVisible = YES;
        [Report_btn setExclusiveTouch:YES];
        [OKStatus_btn setExclusiveTouch:YES];
        helpState = YES;
        _StatusView.image = [UIImage imageNamed:[NSString stringWithFormat:@"step_%i.png",[traveller _currentQuestionCount] - 1]];
        if (isNextQuestion) {
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
                [self.audioPlayer stop];
                [self.audioPlayer2 stop];
                if ([traveller _currentQuestionCount] < 6) {
                    url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MoneyRound1.mp3", [[NSBundle mainBundle] resourcePath]]];
                }
                else if ([traveller _currentQuestionCount] == 6 || [traveller _currentQuestionCount] == 11 )
                {
                    url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Guaranteed.mp3", [[NSBundle mainBundle] resourcePath]]];
                }
                else if ([traveller _currentQuestionCount] > 6 && [traveller _currentQuestionCount] < 11 )
                {
                    url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MoneyRound2.mp3", [[NSBundle mainBundle] resourcePath]]];
                }else if ([traveller _currentQuestionCount] > 11 )
                {
                    url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MoneyRound3.mp3", [[NSBundle mainBundle] resourcePath]]];
                }
                
                NSError *error;
                AVAudioPlayer* audioPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
                audioPlayerTmp.numberOfLoops = 0;
                self.audioPlayer = audioPlayerTmp;
                [self.audioPlayer play];
            }
        }
    }
}

- (IBAction)statusDismiss:(id)sender {
    [[sender superview] removeWithZoomOutNoAnimation:.0f delay: 0 option:UIViewAnimationOptionCurveEaseInOut completionBlock:^{
        [self callAnimButtons:true delay:0];
    }];
    isStatusVisible = NO;
    if (isNextQuestion) {
        self.view.userInteractionEnabled = NO;
        timerLb.text = [NSString stringWithFormat:@"%d",60];
        
        [self animateQuestionChange];
    }
}

- (IBAction)soundButtonPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    [[NSUserDefaults standardUserDefaults]setBool:btn.selected forKey:@"noMusic"];
    if(btn.selected){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }else {
        NSError *error;
        audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer2.numberOfLoops = -1;
        self.audioPlayer = audioPlayer2;
        [self.audioPlayer play];
    }
}

- (IBAction)report_btn:(id)sender {
    if(helpState){
        helpState = NO;
        [self.report_view setHidden:NO];
        [self.view bringSubviewToFront:self.report_view];
    }
}

- (IBAction)send_report:(id)sender {
    helpState = YES;
    UIButton* bt = (UIButton*) sender;
    if ([bt tag] != 0) {
        [self send_report_request:(int)[bt tag]];
    }
    [self.report_view setHidden:YES];
}

#pragma mark - Data Manipulations


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


- (void)DecisionIsMade {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
        [self.audioPlayer2 stop];
        [self.audioPlayer stop];
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/AnswerPressed.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        AVAudioPlayer* audioPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        NSLog(@"ERROR: %@",[error description]);
        audioPlayerTmp.numberOfLoops = 0;
        // [self.audioPlayer stop];
        self.audioPlayer2 = audioPlayerTmp;
        [self.audioPlayer2 play];
    }
    self.view.userInteractionEnabled = NO;
    UIButton *btn = (UIButton*)[self.view viewWithTag:([traveller getTag])];
    NSString *orangeImageName = isIpad ? @"ipad_orange_" : @"orange_";
    [btn setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", orangeImageName, (long)[traveller getTag]] state:UIControlStateNormal];
    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    
    [timerImage.layer removeAllAnimations];
    [timerLb.layer removeAllAnimations];
    [self performSelector:@selector(IsTrueOrNot:) withObject:btn afterDelay:traveller._currentQuestionCount * .3f];
}

- (void) IsTrueOrNot:(UIButton*)btn
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
        [self.audioPlayer2 stop];
    }
    [[btn layer] removeAllAnimations];
    
    if([traveller finalAnswer])//Answer correct
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
            [self.audioPlayer2 stop];
            url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Correct.mp3", [[NSBundle mainBundle] resourcePath]]];
            
            NSError *error;
            AVAudioPlayer* audioPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            audioPlayerTmp.numberOfLoops = 0;
            self.audioPlayer2 = audioPlayerTmp;
            [self.audioPlayer2 play];
        }
        
        if([traveller _currentQuestionCount] > QUESTIONS_MAX)//WIN
        {
            NSString *greenImageName = isIpad ? @"ipad_green_" : @"green_";
            [btn setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", greenImageName, btn.tag] state:UIControlStateNormal];
            
            [self blinkAnimeForView:btn];
            [self performBlock:^{
                self.view.userInteractionEnabled = YES;
                [self stopMusicAndTimer];
                [self performSegueWithIdentifier:@"win_game" sender:self];
            } afterDelay:1.5];
        } else {
            NSString *greenImageName = isIpad ? @"ipad_green_" : @"green_";
            [btn setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", greenImageName, btn.tag] state:UIControlStateNormal];
            
            [self blinkAnimeForView:btn];
            helpState = YES;
            [self performBlock:^{
                NSString *blackImageName = isIpad ? @"ipad_black_" : @"black_";
                [btn setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", blackImageName, btn.tag] state:UIControlStateNormal];
                
                [btn.layer removeAllAnimations];
                self.view.userInteractionEnabled = YES;
                isNextQuestion = YES;
                [self viewStatus:btn];
                if (forgotCrowdHelp == YES)
                {
                    [self.crowd setSelected:NO];
                    [self.crowd setEnabled:NO];
                }
                [_lbscore setText:[NSString stringWithFormat:@"%i",[traveller _score]]];
                [_lb_question_ setText:@""];
                [self callAnimButtons: NO delay:0];
                
            } afterDelay:1.5];
        }
    }
    else //incorect answer
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
            [self.audioPlayer2 stop];
            url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Incorrect.mp3", [[NSBundle mainBundle] resourcePath]]];
            
            NSError *error;
            AVAudioPlayer* audioPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            audioPlayerTmp.numberOfLoops = 0;
            [self.audioPlayer stop];
            self.audioPlayer2 = audioPlayerTmp;
            [self.audioPlayer2 play];
        }
        
        [self FailGame];
    }
    
}

- (void) FailGame{
    
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    UIButton *btn2 = (UIButton*)[self.view viewWithTag:[traveller _correctAnswer]];
    UIButton *btn = (UIButton*)[self.view viewWithTag:[traveller getTag]];
    
    NSString *greenImageName = isIpad ? @"ipad_green_" : @"green_";
    [btn2 setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", greenImageName, (long)[traveller _correctAnswer]] state:UIControlStateNormal];
    
    [self blinkAnimeForView:btn];
    [self blinkAnimeForView:btn2];
    
    [self performBlock:^{
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
            [self.audioPlayer stop];
            [self.audioPlayer2 stop];
            url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Lose.mp3", [[NSBundle mainBundle] resourcePath]]];
            
            NSError *error;
            AVAudioPlayer* audioPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            audioPlayerTmp.numberOfLoops = 0;
            [self.audioPlayer stop];
            self.audioPlayer2 = audioPlayerTmp;
            [self.audioPlayer2 play];
        }
        
        [btn.layer removeAllAnimations];
        [btn2.layer removeAllAnimations];
        self.view.userInteractionEnabled = YES;
        [self stopMusicAndTimer];
        [self performSegueWithIdentifier:@"game_over" sender:self];
        
        NSString *blackImageName = isIpad ? @"ipad_black_" : @"black_";
        [btn setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", blackImageName, btn.tag] state:UIControlStateNormal];
        [btn setBackgroundImageWithName:[NSString stringWithFormat:@"%@%ld", blackImageName, (long)[traveller _correctAnswer]] state:UIControlStateNormal];
    } afterDelay:1.8];
    
    
}

-(void) lockGames {

}

- (void)timerMethod:(NSTimer*)_timer{
    if(tmpTime <= 59) {
        
        if (tmpTime >= 30 && tmpTime < 45) {
            timerCircle.progressColor = [UIColor colorWithRed:251/255.f green:230/250.f blue:82/250.f alpha:1];
        }else if(tmpTime >= 45){
            timerCircle.progressColor = [UIColor colorWithRed:252/255.f green:49/250.f blue:63/250.f alpha:1];
        }
        [timerCircle setStartDegree:tmpTime*360/60 timing:TPPropertyAnimationTimingEaseInEaseOut duration:0 delay:0];
        [timerCircle setEndDegree:360 timing:TPPropertyAnimationTimingEaseInEaseOut duration:0 delay:0];
        
        if(abs(tmpTime-60) >= 10){

        } else if(abs(tmpTime-60) >= 3){

            [self blinkAnimeForView:timerLb];
        } else if(abs(tmpTime-60) < 3) {
            [self blinkAnimeForView:timerCircle];
            [self blinkAnimeForView:timerLb];
        }
        
        timerLb.text = [NSString stringWithFormat:@"%d",abs(tmpTime-60)];
        tmpTime++;
    } else {
        [self stopMusicAndTimer];
        [traveller TimeOut];
        [self performSegueWithIdentifier:@"game_over" sender:self];
        tmpTime = 1;
        [timer invalidate];
        timer = nil;
    }
}

- (void) stopMusicAndTimer
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        
        [self.audioPlayer2 stop];
        self.audioPlayer2 = nil;
    }
    if(timer){
        [timer invalidate];
        timer = nil;
    }
}

-(void) setQuestionData
{
    [self setUpTimerCircle];
    helpState = YES;
    if ([traveller _currentQuestionCount] < 6) {
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Round1.mp3", [[NSBundle mainBundle] resourcePath]]];
    }
    else if ([traveller _currentQuestionCount] >= 6 && [traveller _currentQuestionCount] < 11)
    {
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Round2.mp3", [[NSBundle mainBundle] resourcePath]]];
    }else if ([traveller _currentQuestionCount] >= 11)
    {
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Round3.mp3", [[NSBundle mainBundle] resourcePath]]];
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
        [self.audioPlayer stop];
        NSError *error;
        AVAudioPlayer* audioPlayerTmp = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayerTmp.numberOfLoops = 0;
        
        self.audioPlayer = audioPlayerTmp;
        [self.audioPlayer play];
    }
    isNextQuestion = NO;

    timerLb.text = [NSString stringWithFormat:@"%d",60];
    visible_answers = 4;
    NSMutableArray* arr = traveller.provideQuestion;
    for(int i = 0; i < _bt_answers.count; i++)
        [[_bt_answers objectAtIndex:i] setTitle: [arr objectAtIndex:[[_bt_answers objectAtIndex:i] tag] - 1]forState:UIControlStateNormal];
    [_lb_question_ setText:[arr objectAtIndex:4]];
    [_lb_request_question setText:[arr objectAtIndex:4]];
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    tmpTime = 1;
    [self performBlock:^{  timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES]; } afterDelay:1.f];
}

-(void) SetExclusiveTouch{
    for(int i = 0; i < _bt_answers.count; i++){
        [[_bt_answers objectAtIndex:i] setExclusiveTouch:YES];
    }
    for(int i = 0; i < _bts_help.count; i++){
        [[_bts_help objectAtIndex:i] setExclusiveTouch:YES];
    }
    for(int i = 0; i < Report_btns.count; i++){
        [[Report_btns objectAtIndex:i] setExclusiveTouch:YES];
    }
    [soundBtn setExclusiveTouch:YES];
    [Report_btn setExclusiveTouch:YES];
    [Exit_btn setExclusiveTouch:YES];
}

-(void) use50_50
{
    visible_answers = 2;
    NSMutableArray* bt50_50Answers = [[NSMutableArray alloc] init];
    for(int i = 0; i < _bt_answers.count; i++)
        if(traveller._correctAnswer != [_bt_answers[i] tag])
            [bt50_50Answers addObject: _bt_answers[i]];
    [bt50_50Answers removeObjectAtIndex:arc4random() % bt50_50Answers.count];
    [self animateButtonOut:[bt50_50Answers objectAtIndex:0] left: true delay:0];
    [self animateButtonOut:[bt50_50Answers objectAtIndex:1] left: false delay:0];
}

-(NSMutableArray*) generateAudienceHelpDataForTwoAnswers:(BOOL)forTwo
{
    int m[] = {0,0,0,0};
    int curQest = ([traveller _currentQuestionCount] > 15) ? 15 : [traveller _currentQuestionCount];
    if(forTwo && visible_answers == 2)
    {
        if(curQest<=4) curQest = curQest + arc4random() % 2;
        else if(curQest>4 && curQest<=8) curQest = curQest + arc4random() % 2;
        else if(curQest>8 && curQest<= 11) curQest = curQest + arc4random()% 2 - 3;
        else curQest = curQest + arc4random() % 2 - 3;
        m[[traveller _correctAnswer] - 1] = 100 -5*curQest;
        if(arc4random() % 2 == 0)
            m[[traveller _correctAnswer] - 1] += arc4random() % 5;
        else m[[traveller _correctAnswer] - 1] -= arc4random() % 5;
        for(int i = 0; i < 4; i++)
            if((btAnswerStatus[i] == BT_ANSWER_IN) && i != [traveller _correctAnswer] - 1)
            {
                m[i] = 100 - m[[traveller _correctAnswer] - 1];
                break;
            }
    }
    else
    {
        
        int k = 0;
        if(curQest<=4) curQest = curQest + arc4random() % 4;
        else if(curQest>4 && curQest<=8) curQest = curQest + arc4random() % 2;
        else if(curQest>8 && curQest<= 11) curQest = curQest + arc4random()% 2 - 3;
        else curQest = curQest + arc4random() % 1;
        m[[traveller _correctAnswer] - 1] = 100 -5*curQest;
        if(arc4random() % 2 == 0)
            m[[traveller _correctAnswer] - 1] += arc4random() % 5;
        else m[[traveller _correctAnswer] - 1] -= arc4random() % 5;
        for(int i = 0; i < 4; i++)
            if (i != [traveller _correctAnswer] - 1)
            {
                ++k;
                if(k == 3) m[i] = 100 - (m[0]+m[1]+m[2]+m[3]);
                else m[i] = arc4random() % (101 -(m[0]+m[1]+m[2]+m[3]));
            }
    }
    NSMutableArray* m1 = [[NSMutableArray alloc] init];
    for(int i = 0; i < 4; i++)
        [m1 addObject: [[NSNumber alloc] initWithInt:m[i]]];
    return m1;
}


#pragma mark - Animation Methods

- (void)blinkAnimeForView:(UIView *)view{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setDuration:0.25f];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:3];
    [[view layer] addAnimation:animation forKey:@"opacity"];
}

-(void)willEnterForeground
{
    if (isAnimationStarted && !isStatusVisible) {
        
        for(int i = 0; i < _bt_answers.count; i++) {
            if (btAnswerStatus[i] == BT_ANSWER_TRANS) {
                [[_bt_answers objectAtIndex:i] setOriginX: buttonsOrigin[i]];
                btAnswerStatus[i] = BT_ANSWER_IN;
            }
            else if(btAnswerStatus[i] == BT_ANSWER_OUT && visible_answers !=2)
            {
                [[_bt_answers objectAtIndex:i] setOriginX: buttonsOrigin[i]];
                btAnswerStatus[i] = BT_ANSWER_IN;
            }
        }
        self.view.userInteractionEnabled = YES;
        isAnimationStarted = NO;
    }
}

-(void) animateQuestionChange
{
    [self setQuestionData];
    [_lb_question_ fadeFrom:1
                         to:0
                       time:.3f
                      delay:0
                     option:UIViewAnimationOptionCurveEaseInOut
                      block:^(BOOL finished)
     {
         if(finished)
         {
             [_lb_question_ fadeFrom:0 to:1 time: .5f delay: 0 option:UIViewAnimationOptionCurveEaseInOut block: nil];
         }
     }];
}

#pragma mark - General Methods

+(id) getElementFromArray:(NSArray *)arr withTag:(int)tag
{
    if(arr.count != 0)
    {
        for(int i = 0; i < arr.count; i++)
            if([arr[i] tag] == tag)
                return arr[i];
    }
    return nil;
}

-(void) animateButtonIn:(UIButton *)button left:(BOOL)isLeft delay:(float)secs {
    if(btAnswerStatus[button.tag - 1] == BT_ANSWER_OUT)
    {
        btAnswerStatus[button.tag - 1] = BT_ANSWER_TRANS;
        isAnimationStarted = YES;

        [self.view layoutIfNeeded];
        
        NSLayoutConstraint *constraint = [self constraintFor:button];
        constraint.constant = 0;
        
        [UIView animateWithDuration:.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            btAnswerStatus[button.tag - 1] = BT_ANSWER_IN;
            self.view.userInteractionEnabled = YES;
        }];
    }
}

-(void) animateButtonOut:(UIButton *)button left:(BOOL)isLeft delay:(float)secs {
    if(btAnswerStatus[button.tag - 1] == BT_ANSWER_IN) {
        btAnswerStatus[button.tag - 1] = BT_ANSWER_TRANS;
        isAnimationStarted = YES;

        [self.view layoutIfNeeded];
        
        CGFloat screenWidth = CGRectGetWidth(self.view.frame);
        
        NSLayoutConstraint *constraint = [self constraintFor:button];
        CGFloat center = screenWidth + CGRectGetWidth(button.frame) / 2;
        constraint.constant = isLeft ? center : -center;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            btAnswerStatus[button.tag - 1] = BT_ANSWER_OUT;
        }];
    }
}

-(void) callAnimButtons:(BOOL)IN delay:(float)secs {
    for(int i = 0; i < _bt_answers.count; i++) {
        if(IN) {
            [self animateButtonIn:_bt_answers[i] left:([_bt_answers[i] tag] % 2 == 0) ? NO : YES delay:secs];
        } else {
            [self animateButtonOut:_bt_answers[i] left:([_bt_answers[i] tag] % 2 == 0) ? NO : YES delay:secs];
        }
    }
}

-(NSLayoutConstraint *) constraintFor:(UIButton *)button {
    for (NSLayoutConstraint *constraint in answerButtonCenterConstraints) {
        NSInteger constraintIdentifier = constraint.identifier.integerValue;
        if (constraintIdentifier == button.tag) {
            return constraint;
        }
    }
    
    return nil;
}

@end
