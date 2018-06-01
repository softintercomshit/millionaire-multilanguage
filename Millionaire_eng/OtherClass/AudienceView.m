#import "AudienceView.h"
#define YellowColor [UIColor colorWithRed:255/255.f green:201/255.f blue:28/255.f alpha:1].CGColor

@implementation AudienceView{
    CAShapeLayer *fillingShape;
    CALayer *bottomLayer;
    float _percents;
    UILabel *infoLabel;
}

- (void)animateWithPercents:(float)percents duration:(CFTimeInterval)duration{
    _percents = percents;
    //create the initial and the final path.
    UIBezierPath *fromPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0)];
    
    float viewHeight = self.frame.size.height;
    float scale = viewHeight - (viewHeight * percents);
    
    CGRect toPathRect = CGRectMake(0, scale, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - scale);
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:toPathRect];
    //create the shape layer that will be animated
    fillingShape = [CAShapeLayer layer];
    fillingShape.path = fromPath.CGPath;
    [fillingShape setFillColor:YellowColor];
    
    bottomLayer = [CALayer layer];
    [bottomLayer setBackgroundColor:YellowColor];
    [bottomLayer setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-4, CGRectGetWidth(self.frame), 4)];
    [self.layer addSublayer: bottomLayer];
    
    //create the animation for the shape layer
    CABasicAnimation *animatedFill = [CABasicAnimation animationWithKeyPath:@"path"];
    animatedFill.duration = duration;
    animatedFill.fromValue = (id)fromPath.CGPath;
    animatedFill.toValue = (id)toPath.CGPath;
    animatedFill.fillMode = kCAFillModeForwards;
    animatedFill.removedOnCompletion = NO;
    
    //using CATransaction like this we can set a completion block
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [self setLabelAfterAnimationWithFrame:toPathRect];
    }];
    
    //add the animation to the shape layer, then add the shape layer as a sublayer on the view changing color
    [fillingShape addAnimation:animatedFill forKey:@"path"];
    [self.layer addSublayer:fillingShape];
    
    [CATransaction commit];
}

-(void)setLabelAfterAnimationWithFrame:(CGRect)frame {
    CGRect labelRect = frame;
    labelRect.origin.y -= 30;
    labelRect.size.height = 20;
    infoLabel = [[UILabel alloc] initWithFrame:labelRect];
    [infoLabel setText:[NSString stringWithFormat:@"%.0f %%", _percents*100]];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setFont:[UIFont systemFontOfSize:isIpad ? 22 : 18]];
    [infoLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:infoLabel];
}

-(void)willRotate{
    [fillingShape removeFromSuperlayer];
    [bottomLayer removeFromSuperlayer];
    [infoLabel removeFromSuperview];
    [self layoutIfNeeded];
}

-(void)didRotate{
    [self animateWithPercents:_percents duration:0];
}
@end
