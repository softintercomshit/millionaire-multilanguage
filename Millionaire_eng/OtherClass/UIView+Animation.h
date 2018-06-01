#import <UIKit/UIKit.h>

@interface UIView (Animation)

#pragma mark -
#pragma mark Properties
-(CGPoint) setOriginX: (CGFloat) x;
-(CGPoint) setOriginY: (CGFloat) y;
-(void) setOrigin: (CGPoint) origin;

#pragma mark -
#pragma mark Add View With Animations

- (void) addSubviewWithZoomInAnimation: (UIView*)view
                              duration: (float)secs
                                 delay: (float)delay
                                option: (UIViewAnimationOptions)option
                                 block: (void(^)(BOOL)) onFinish;

- (void) addSubviewWithoutZoomInAnimation: (UIView*)view
                              duration: (float)secs
                                 delay: (float)delay
                                option: (UIViewAnimationOptions)option
                                 block: (void(^)(BOOL)) onFinish;

- (void) addSubviewWithFadeInAnimation: (UIView*)view
                              duration: (float)secs
                                 delay: (float)delay
                                option: (UIViewAnimationOptions)option
                                 block: (void(^)(BOOL)) onFinish;


- (void) removeWithZoomOutAnimation: (float)secs
                              delay: (float)delay
                             option: (UIViewAnimationOptions)option;

- (void) removeWithZoomOutNoAnimation: (float)secs
                              delay: (float)delay
                             option: (UIViewAnimationOptions)option;


- (void) removeWithZoomOutAnimation: (float)secs
                              delay: (float)delay
                             option: (UIViewAnimationOptions)option
                              block: (void(^)(BOOL)) onFinish;

- (void) removeWithZoomOutNoAnimation:(float)secs
                                delay:(float)delay
                               option:(UIViewAnimationOptions)option
                      completionBlock:(void(^)(void))completionBlock;


#pragma mark -
#pragma mark MyAnimations
-(void) translateFrom: (CGPoint) loc1
                   to: (CGPoint) loc2
                 time: (float) secs
                delay: (float) delay
               option: (UIViewAnimationOptions) option
                block: (void(^)(BOOL)) onFinish;

- (void) scaleFromX:(float) fromX
                toX:(float) toX
              fromY:(float) fromY
                toY:(float) toY
           duration:(float)secs
              delay:(float)delay
             option:(UIViewAnimationOptions)option
              block:(void (^)(BOOL))onFinish;

-(void) fadeFrom: (float) f1
              to: (float) f2
            time: (float) secs
           delay: (float) delay
          option: (UIViewAnimationOptions) option
           block: ( void(^)(BOOL)) onFinish;
@end
