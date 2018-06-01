#import "MainViewController.h"
#import "JSONKit.h"
#import <unistd.h>
#import "SICGalleryViewController.h"
#import "SICAds.h"
#import "AFNetworking.h"
#import "UIDevice+Hardware.h"
#import "RemovesService.h"
#import "UpdatesService.h"
#import "InsertsService.h"


@interface MainViewController (){
    __weak IBOutlet UIView *mainController;
    __weak IBOutlet UIImageView *logoImageView;
    double serverDBVersion, localDBVersion;
    NSString *updateInfo;
}

@end

@implementation MainViewController

@synthesize audioPlayer;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupButtonsIcons];
    [logoImageView setImageWithName:isIpad ? @"ipad_logo.png".localized : @"logo.png".localized];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"fullVisible"])
        [Full_btn setHidden:NO];
    if(![self.audioPlayer isPlaying]) {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
            [self.audioPlayer stop];
            NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Main.mp3", [[NSBundle mainBundle] resourcePath]]];
            
            NSError *error;
            AVAudioPlayer* audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            audioPlayer2.numberOfLoops = -1;
            self.audioPlayer = audioPlayer2;
            [self.audioPlayer play];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mainController addToSafeArea];
    
    [play_btn setExclusiveTouch:YES];
    [HowToPlay_btn setExclusiveTouch:YES];
    [score_btn setExclusiveTouch:YES];
    [soundBtn setExclusiveTouch:YES];
    [Update_btn setExclusiveTouch:YES];
    [Download_btn setExclusiveTouch:YES];
    [Cancel_btn setExclusiveTouch:YES];
    [Full_btn setExclusiveTouch:YES];
    [buy_button setExclusiveTouch:YES];
    [wait_button setExclusiveTouch:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults integerForKey:@"times"])
    {
        [defaults setInteger:1 forKey:@"times"];
        [defaults setBool:YES forKey:@"can_play"];
        [defaults synchronize];
    }
    
    [_lang_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[defaults stringForKey:@"localization"]]] forState:UIControlStateNormal];
    
    [self checkUpdates];
    [self checkGallery];
    
	soundBtn.selected = [[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"];

}

-(void)setupButtonsIcons {
    [play_btn setBackgroundImageWithName:@"plashka" state:UIControlStateNormal];
    [play_btn setBackgroundImageWithName:@"plashka_select" state:UIControlStateHighlighted];
    
    [HowToPlay_btn setBackgroundImageWithName:@"plashka" state:UIControlStateNormal];
    [HowToPlay_btn setBackgroundImageWithName:@"plashka_select" state:UIControlStateHighlighted];
    
    [score_btn setBackgroundImageWithName:@"plashka" state:UIControlStateNormal];
    [score_btn setBackgroundImageWithName:@"plashka_select" state:UIControlStateHighlighted];
    
    [Full_btn setBackgroundImageWithName:@"plashka_select" state:UIControlStateNormal];
    
    [Download_btn setBackgroundImageWithName:@"plashka_select" state:UIControlStateNormal];
    
    [Cancel_btn setBackgroundImageWithName:@"plashka" state:UIControlStateNormal];
    [Cancel_btn setBackgroundImageWithName:@"plashka_select" state:UIControlStateHighlighted];
    
    [Update_btn setBackgroundImageWithName:@"plashka_select" state:UIControlStateNormal];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self checkUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"start_game"])
    {
        if([audioPlayer isPlaying])
        {
            [self.audioPlayer stop];
            self.audioPlayer = nil;
        }
    }
}

- (void)timerMethod:(NSTimer*)_timer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *myDate = [NSDate date];
    NSDate *waitingDate = [defaults objectForKey:@"timer"];
    
    NSComparisonResult result = [myDate compare:waitingDate];
    if(result == NSOrderedDescending)
    {
        [timer invalidate];
        timer = nil;
        [[[timer_label superview] superview] removeWithZoomOutNoAnimation:.0f delay:0 option:UIViewAnimationCurveEaseInOut];
    }
    
    NSTimeInterval lastDiff = [waitingDate timeIntervalSinceNow];
    NSTimeInterval todaysDiff = [myDate timeIntervalSinceNow];
    NSTimeInterval dateDiff = lastDiff - todaysDiff;
    
    int day = dateDiff / 86400;
    int hours = (dateDiff-(day *86400))/3600 ;;
    int minutes = ((dateDiff -(day*86400))-hours*3600)/60;
    int seconds = (((dateDiff-(day*86400))-hours*3600)-minutes*60);
    if ((day == 0 && hours == 0 && minutes == 0 && seconds == 0) || result == NSOrderedDescending) {
        [timer invalidate];
        timer = nil;
        [[[timer_label superview] superview] removeWithZoomOutNoAnimation:.0f delay:0 option:UIViewAnimationCurveEaseInOut];
    }
    else
    {
        if (day > 0)
        {
            [timer_label setText:[NSString stringWithFormat:@"%0.2d : %0.2d : %0.2d : %0.2d", day, hours, minutes, seconds]];
        }
        else
        {
            [timer_label setText:[NSString stringWithFormat:@"%0.2d : %0.2d : %0.2d", hours, minutes, seconds]];
        }
    }
}

- (IBAction)ShowInterstitial:(UIButton *)sender {
    [SICAds show];
    
    UIButton* bt = (UIButton*) sender;
    [[[bt superview] superview] removeWithZoomOutNoAnimation:.0f delay:0 option:UIViewAnimationCurveEaseInOut];
}

- (IBAction)WaitAction:(UIButton *)sender {
    [timer invalidate];
    timer = nil;
    UIButton* bt = (UIButton*) sender;
    [[[bt superview] superview] removeWithZoomOutNoAnimation:.0f delay:0 option:UIViewAnimationCurveEaseInOut];
    
}

- (IBAction)PlayGame:(UIButton *)sender {
    [self performSegueWithIdentifier:@"start_game" sender:sender];
}

- (IBAction)sendSuportAction:(UIButton *)sender {
    UIButton* bt = (UIButton*) sender;
    [[[bt superview] superview] removeWithZoomOutNoAnimation:.0f delay:0 option:UIViewAnimationCurveEaseInOut];
    if (sender.tag == 1)
    {
        NSArray  *toRecipents = [NSArray  arrayWithObject:@"sic.sp.millionaire@gmail.com"];
        // password for email: softintercom
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        NSString  *emailTitle = @"Millionaire: Suport";
        [mc setSubject:emailTitle];
        
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        NSString *currDeiceVer = [UIDevice currentDevice].modelName;
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        NSString *messageBody = [NSString stringWithFormat:@"********************\nDevice: %@\nModel: %@\nApplication Version: %@\nApplication Name: %@\n\n********************", currSysVer, currDeiceVer, currentVersion, appName];
        [mc setMessageBody:messageBody isHTML:false];
        
        mc.mailComposeDelegate = self;
        [mc setToRecipients:toRecipents];
        [self presentViewController:mc animated:YES completion:NULL];

    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError  *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)ShowSuportView:(UIButton *)sender {
    UIView* uiv = (UIView*) [CustomView newCustomView:isIpad ? @"ContactView_ipad" : @"ContactView" owner:self];
    uiv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubviewWithoutZoomInAnimation:uiv
                                       duration:.0f
                                          delay:0
                                         option:UIViewAnimationCurveEaseInOut
                                          block:nil];
}

- (IBAction)soundButtonPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    [[NSUserDefaults standardUserDefaults]setBool:btn.selected forKey:@"noMusic"];
    if(btn.selected){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        
    }else {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Main.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        AVAudioPlayer* audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer2.numberOfLoops = -1;
        
        self.audioPlayer = audioPlayer2;
        [self.audioPlayer play];

    } 
}

- (IBAction)Update:(id)sender {
    // set database info
    [_database_update_textView setText: updateInfo];
    
    // show view
    [self.database_update_view setHidden:NO];
}

- (IBAction)Update_database:(id)sender {
    UIButton* bt = (UIButton*) sender;
    if([bt tag] == 1)//Yes
    {
        [_database_update_view setHidden:YES];
        HUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:HUD];// Set determinate mode
        HUD.delegate = self;
        HUD.labelText = @"Connecting";
        HUD.minSize = CGSizeMake(135.f, 135.f);
        [HUD show:YES];
        [self getUpdate];
    }
    if([bt tag] == 0)//No
    {
        [self.database_update_view setHidden:YES];
    }
}

- (IBAction)change_language:(id)sender {
    if(isIpad){
        [self.view addSubviewWithoutZoomInAnimation:[CustomView newCustomView:@"LanguagesView_ipad" owner:self]
                                           duration:.0f
                                              delay:0
                                             option:UIViewAnimationCurveEaseInOut
                                              block:nil];
    } else {
        [self.view addSubviewWithoutZoomInAnimation:[CustomView newCustomView:@"LanguagesView" owner:self]
                                           duration:.0f
                                              delay:0
                                             option:UIViewAnimationCurveEaseInOut
                                              block:nil];
    }
}

- (IBAction)set_language:(UIButton *)sender {
    NSString *currentLanguage;
    
    switch ([sender tag]) {
        case 1:
            currentLanguage = @"en";
        break;
        case 2:
            currentLanguage = @"de";
            break;
        case 3:
            currentLanguage = @"es";
            break;
        case 4:
            currentLanguage = @"it";
            break;
        case 5:
            currentLanguage = @"ru";
            break;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentLanguage forKey:@"localization"];
    [defaults synchronize];
    
    if([audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    [[[sender superview] superview] removeWithZoomOutNoAnimation:.75 delay:0 option:UIViewAnimationCurveEaseInOut];

    [_lang_btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", currentLanguage]] forState:UIControlStateNormal];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setRootController];
}

- (IBAction)closeLanguage:(id)sender {
    UIButton* bt = (UIButton*) sender;
    [[[bt superview] superview] removeWithZoomOutNoAnimation:.75 delay:0 option:UIViewAnimationCurveEaseInOut];
}

- (IBAction)Upgrade_to_paid:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [defaults objectForKey:@"itunesLink"]]];
}

#pragma mark - SICAds

- (IBAction)showSicGallery:(UIButton *)sender
{
    if ([SICGalleryViewController canShow]) {
        SICGalleryViewController *galleryVC = [SICGalleryViewController new];
        [galleryVC showInFullscreenMode:NO staticHeader:YES];
    } else {
        buttonGallery.hidden = YES;
        [self checkGallery];
    }
}



- (void)checkGallery {
    if ([SICGalleryViewController canShow]) {
        buttonGallery.hidden = NO;
    } else {
        [self performSelector:@selector(checkGallery) withObject:nil afterDelay:2];
    }
}


- (void) getUpdate {
    NSString *params = [NSString stringWithFormat:@"%f/%@/", localDBVersion, [NSBundle mainBundle].bundleIdentifier];
    NSString *removesUrl = BASE_URL([@"api/getremoves/" stringByAppendingString:params]);
    NSString *insertsUrl = BASE_URL([@"api/getinserts/" stringByAppendingString:params]);
    NSString *updatesUrl = BASE_URL([@"api/getupdates/" stringByAppendingString:params]);
    
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Updating";
    
    void (^showError)() = ^void() {
        HUD.labelText = @"No Internet access";
        HUD.mode = MBProgressHUDModeText;
        [self performSelector:@selector(cleanUp) withObject:nil afterDelay:1.0];
    };
    
    // step1: get ids that should be removed
    [RestClient get:removesUrl params:nil onSucces:^(id result) {
        [RemovesService removeQuestions:result];
        
        // step2: get ids that should be updated
        [RestClient get:updatesUrl params:nil onSucces:^(id result) {
            [UpdatesService updatesQuestions:result];
            
            // step3: get new inserts
            [RestClient get:insertsUrl params:nil onSucces:^(id result) {
                [InsertsService insertQuestions:result];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setDouble:serverDBVersion forKey:kDatabaseVersion];
                [defaults synchronize];
                
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.labelText = @"Completed";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_database_update_btn setHidden:YES];
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                });
                [self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:YES];
            } onFail:^(NSError *error) {
                showError;
            }];
        } onFail:^(NSError *error) {
            showError;
        }];
    } onFail:^(NSError *error) {
        showError;
    }];
}

-(void) cleanUp{
    sleep(1);
    [HUD hide:YES];
}

- (void) checkUpdates
{
    NSString *url = [NSString stringWithFormat:@"%@%@/", BASE_URL(@"api/bundle/"), [NSBundle mainBundle].bundleIdentifier];
    
    [RestClient get:url params:nil onSucces:^(id result) {
        serverDBVersion = [result[@"db_version"] doubleValue];
        updateInfo = result[@"update_info"];
        localDBVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:kDatabaseVersion];
        BOOL needToUpdate = serverDBVersion != localDBVersion;
        [_database_update_btn setHidden:!needToUpdate];
    } onFail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


- (void)viewDidUnload {
    [self setDatabase_update_view:nil];
    [self setDatabase_update_subview:nil];
    [self setLang_btn:nil];
    play_btn = nil;
    HowToPlay_btn = nil;
    score_btn = nil;
    Download_btn = nil;
    Cancel_btn = nil;
    Update_btn = nil;
    Full_btn = nil;
    [super viewDidUnload];
}
@end
