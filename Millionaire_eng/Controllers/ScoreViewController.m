#import "ScoreViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation ScoreViewController {
    __weak IBOutlet UIView *mainConteiner;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIImageView *scoreImageView;
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
    _scoreTable.tableFooterView = [UIView new];
    [mainConteiner addToSafeArea];
    
    [self sortStorage];
    _scoreTable.layer.cornerRadius = 6;
    [_scoreTable reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupButtonsIcons];
}

-(void)setupButtonsIcons {
    [backButton setBackgroundImageWithName:@"button_white" state:UIControlStateNormal];
    [backButton setBackgroundImageWithName:@"button_white_click" state:UIControlStateHighlighted];
    
    [scoreImageView setImageWithName:@"plashka"];
}

- (void)viewDidUnload
{
    [self setScoreTable:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goto_GameCenterLeaderboards:(id)sender {
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
            gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeAllTime;
            gameCenterController.leaderboardCategory = kHighScoreLeaderboardID;
            [self presentViewController: gameCenterController animated: YES completion:nil];
        }
    }else{
        GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
        if (leaderboardController != NULL)
        {
            leaderboardController.category = kHighScoreLeaderboardID;
            leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
            leaderboardController.leaderboardDelegate = self;
            [self presentViewController: leaderboardController animated: YES completion:nil];
        }
    }
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    NSLog(@"some text to understand if function is called or not");
	[self dismissViewControllerAnimated: YES completion:nil];
}

#pragma mark - UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return storage.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreTableCell *cell;
    if (isIpad) {
        static NSString *simpleTableIdentifier = @"myCell_ipad";
        cell = (ScoreTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = (ScoreTableCell*)[CustomView newCustomView:@"ScoreCell_ipad" owner:self];
        }
    }
    else{
        static NSString *simpleTableIdentifier = @"myCell";
        cell = (ScoreTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = (ScoreTableCell*)[CustomView newCustomView:@"ScoreCell" owner:self];
        }
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    NSMutableDictionary *dict = [storage objectAtIndex:indexPath.row];
    cell.rowNr.text = [NSString stringWithFormat:@"%ld.",indexPath.row + 1];
    cell.pName.text = [dict objectForKey:@"name"];
    cell.sc.text    = [NSString stringWithFormat:@"%d",[[dict objectForKey:@"score"]intValue]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //        [drinks removeObjectAtIndex:indexPath.row];
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ta.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) sortStorage{
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"score"];
    if(array)
        storage =[NSMutableArray arrayWithArray:array];
    else {
        storage = [[NSMutableArray alloc]init];
    }
    NSSortDescriptor *aSortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSSortDescriptor *aSortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [storage sortUsingDescriptors:[NSArray arrayWithObjects:aSortDescriptor1,aSortDescriptor2,nil]];
}

- (IBAction)goToMain:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
