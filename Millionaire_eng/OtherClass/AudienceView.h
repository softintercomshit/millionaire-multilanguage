#import <UIKit/UIKit.h>

@interface AudienceView : UIImageView

- (void)animateWithPercents:(float)percents duration:(CFTimeInterval)duration;
- (void)didRotate;
- (void)willRotate;

@end
