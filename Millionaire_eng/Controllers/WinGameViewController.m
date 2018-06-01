#import "WinGameViewController.h"
#import "SICAds.h"


@interface WinGameViewController ()

@end

@implementation WinGameViewController{
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
        [_save setEnabled:(newLength + string.length > 0) ? YES : NO];
    else
        [_save setEnabled:(newLength - string.length > 0) ? YES : NO];
    
    return (newLength > 14) ? NO : YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
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
    
    [SICAds show];
    
    [self.goMain setExclusiveTouch:YES];
    [self.save setExclusiveTouch:YES];
    
    if ([traveller _score] > 0) [self send_score];
    
    _winner_name.delegate = self;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"]){
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/WinMillion.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        NSLog(@"ERROR: %@",[error description]);
        audioPlayer2.numberOfLoops = 0;
        [audioPlayer2 play];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [logoImageView setImageWithName:isIpad ?  @"Logo_Milionaire_HD".localized : @"logo_win.png".localized];
    [self setupButtonsIcons];
}

-(void)setupButtonsIcons {
    [_save setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
    
    [_goMain setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    CGRect frame = [_winner_name convertRect:_winner_name.bounds toView:self.view];
    keyboardHandler.textFieldFrame = frame;
}

- (void)viewDidUnload
{
    [self setSave:nil];
    [self setWinner_name:nil];
    [self setGoMain:nil];
    [super viewDidUnload];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"])
    { [audioPlayer2 stop];
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
        [traveller addRecordWithUserName:_winner_name.text];
    }
    [_winner_name resignFirstResponder];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)nameEnterDone:(id)sender
{
    [sender resignFirstResponder];
    [_save setEnabled:([_winner_name text].length != 0) ? YES : NO];
}

@end
