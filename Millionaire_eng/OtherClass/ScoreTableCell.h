//
//  ScoreTableCell.h
//  Millionaire_rus
//


#import <UIKit/UIKit.h>

@interface ScoreTableCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *rowNr;
@property (strong, nonatomic) IBOutlet UILabel *pName;
@property (strong, nonatomic) IBOutlet UILabel *sc;

@end
