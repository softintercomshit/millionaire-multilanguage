//
//  CustomView.m
//  Millionaire_rus
//


#import "CustomView.h"

@implementation CustomView

+ (id) newCustomView:nibName owner: o
{
	UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
	NSArray *nibArray = [nib instantiateWithOwner:o options:nil];
    CustomView *cv = [nibArray objectAtIndex: 0];
    cv.frame = [UIScreen mainScreen].bounds;
	return cv;
}
@end
