#import "UIView+Animation.h"

@implementation UIView (Animation)

#pragma mark -
#pragma mark Properties

-(CGPoint) setOriginX:(CGFloat)x
{
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    return self.frame.origin;
}

-(CGPoint) setOriginY:(CGFloat)y
{
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
    return self.frame.origin;
}

-(void) setOrigin:(CGPoint)origin
{
    [self setFrame:CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height)];
}

#pragma mark -
#pragma mark Add View With Animations

- (void) addSubviewWithZoomInAnimation:(UIView *)view duration:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option block:(void (^)(BOOL))onFinish
{
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;	// do it instantly, no animation
    [self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs
                          delay:delay
                        options:option
                     animations:^{view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);}
                     completion:onFinish];

}
- (void) addSubviewWithoutZoomInAnimation:(UIView *)view duration:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option block:(void (^)(BOOL))onFinish
{
    [self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs
                          delay:delay
                        options:option
                     animations:^{}
                     completion:onFinish];
}
-(void) addSubviewWithFadeInAnimation:(UIView *)view duration:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option block:(void (^)(BOOL))onFinish
{
    view.alpha = 0;
    [self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:delay options:option
                     animations:^{view.alpha = 1;}
                     completion:onFinish];
}

- (void) removeWithZoomOutAnimation:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option
{
	[UIView animateWithDuration:secs delay:delay options:option
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished){[self removeFromSuperview];}];
}

- (void) removeWithZoomOutNoAnimation:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option
{
	[UIView animateWithDuration:secs delay:delay options:option
                     animations:^{}
                     completion:^(BOOL finished){[self removeFromSuperview];}];
}

- (void) removeWithZoomOutNoAnimation:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option completionBlock:(void(^)(void))completionBlock
{
    [UIView animateWithDuration:secs delay:delay options:option
                     animations:^{}
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         if (completionBlock) {
                             completionBlock();
                         }
                     }];
}

-(void) removeWithZoomOutAnimation:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option block:(void (^)(BOOL))onFinish
{
    [UIView animateWithDuration:secs delay:delay options:option
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
                     }
                     completion:onFinish];

}


#pragma mark -
#pragma mark Animations

-(void) translateFrom:(CGPoint)loc1 to:(CGPoint)loc2 time:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option block:(void (^)(BOOL))onFinish
{
    [self setFrame:CGRectMake(loc1.x, loc1.y, self.frame.size.width, self.frame.size.height)];
    
    [UIView animateWithDuration:secs
                          delay:delay
                        options:option
                     animations:^
     {
        self.frame = CGRectMake(loc2.x, loc2.y, self.frame.size.width, self.frame.size.height);
     }
                     completion: onFinish];
}

- (void) scaleFromX:(float)fromX toX:(float)toX fromY:(float)fromY toY:(float)toY duration:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option block:(void (^)(BOOL))onFinish
{
    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(self.transform, fromX, fromY);
    self.transform = trans;	// do it instantly, no animation
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs
                          delay:delay
                        options:option
                     animations:^{self.transform = CGAffineTransformScale(self.transform, toX, toY);}
                     completion:onFinish];
}

-(void) fadeFrom:(float)f1 to:(float)f2 time:(float)secs delay:(float)delay option:(UIViewAnimationOptions)option block:(void (^)(BOOL))onFinish
{
    self.alpha = f1;
    [UIView animateWithDuration:secs delay:delay options:option
                     animations:^{self.alpha = f2;}
                     completion:onFinish];
}


@end
