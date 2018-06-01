#import "HelpViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HelpViewController ()

@end

@implementation HelpViewController {
    __weak IBOutlet UIView *mainConteiner;
    __weak IBOutlet UIView *scrollViewConteiner;
    IBOutletCollection(UIImageView) NSArray *plashkaImageView;
    __weak IBOutlet UIButton *backButton;
}

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
    
    [mainConteiner addToSafeArea];
    
    [scroll_view setScrollEnabled:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupButtonsIcons];
}

-(void)setupButtonsIcons {
    [backButton setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
    [backButton setBackgroundImageWithName:@"button_white_click" state:UIControlStateHighlighted];
    
    for (UIImageView *imageView in plashkaImageView) {
        [imageView setImageWithName:@"plashka"];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [scroll_view setContentSize: scrollViewConteiner.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    scroll_view = nil;
    [super viewDidUnload];
}

- (IBAction)goToMain:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
