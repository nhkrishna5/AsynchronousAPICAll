//
//  UIView+AnimationView.m
//  WalkThroughObjc
//
//  Created by CSS on 13/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

#import "UIView+AnimationView.h"
#import <objc/runtime.h>

@implementation UIView (AnimationView)

static char animationDur, animationDel, animationTyp;

@dynamic Animation_Duration;
@dynamic Animation_Delay;
@dynamic Animation_Type;


-(void)awakeFromNib{
    [super awakeFromNib];
    
    NSLog(@"%ld",(long)self.Animation_Type);
    NSLog(@"%ld",(long)self.Animation_Delay);
    NSLog(@"%ld",(long)self.Animation_Duration);
    
    [self setAnimationAppearence:self.Animation_Duration WithDelay:self.Animation_Delay WithAnimationType:self.Animation_Type];
    
    
    
    
  
}


-(void)setAnimation_Type:(NSInteger)Animation_Type{
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)Animation_Type];
    
    objc_setAssociatedObject(self, &animationTyp, str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSInteger)Animation_Type{
    
    return [objc_getAssociatedObject(self, &animationTyp) integerValue];
    
}


-(void)setAnimation_Delay:(float)Animation_Delay{
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)Animation_Delay];
    
    objc_setAssociatedObject(self, &animationDel, str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(float)Animation_Delay{
    
    return [objc_getAssociatedObject(self, &animationDel) integerValue];
}


-(void)setAnimation_Duration:(float)Animation_Duration{
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)Animation_Duration];
    
    objc_setAssociatedObject(self, &animationDur, str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(float)Animation_Duration{
    
    return [objc_getAssociatedObject(self, &animationDur) integerValue];
}

-(void)setAnimationAppearence :(float)Duration WithDelay :(float)Delay WithAnimationType :(animationType)type{
    
    switch (type) {
            
        case BounceLeft:{
            self.transform = CGAffineTransformMakeTranslation(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
            [UIView animateKeyframesWithDuration:Duration/4 delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeTranslation(-10, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                    // End
                    self.transform = CGAffineTransformMakeTranslation(5, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                        // End
                        self.transform = CGAffineTransformMakeTranslation(-2, 0);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                            // End
                            self.transform = CGAffineTransformMakeTranslation(0, 0);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
        }
            break;
            
        case BounceRight:{
            self.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth([UIScreen mainScreen].bounds), 0);
            [UIView animateKeyframesWithDuration:Duration/4 delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeTranslation(10, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                    // End
                    self.transform = CGAffineTransformMakeTranslation(-5, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                        // End
                        self.transform = CGAffineTransformMakeTranslation(2, 0);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                            // End
                            self.transform = CGAffineTransformMakeTranslation(0, 0);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
            
        }
            
            break;
            
        case BounceTop:{
            self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight([UIScreen mainScreen].bounds));
            [UIView animateKeyframesWithDuration:Duration/4 delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeTranslation(0, 10);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                    // End
                    self.transform = CGAffineTransformMakeTranslation(0, -5);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                        // End
                        self.transform = CGAffineTransformMakeTranslation(0, 2);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                            // End
                            self.transform = CGAffineTransformMakeTranslation(0, 0);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
            
        }
            
            break;
        case BounceDown:{
            
            self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight([UIScreen mainScreen].bounds));
            [UIView animateKeyframesWithDuration:Duration/4 delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeTranslation(0, -10);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                    // End
                    self.transform = CGAffineTransformMakeTranslation(0, 5);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                        // End
                        self.transform = CGAffineTransformMakeTranslation(0, -2);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                            // End
                            self.transform = CGAffineTransformMakeTranslation(0, 0);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
            
        }
            
            break;
            
            
        case SlideTop:{
            self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight([UIScreen mainScreen].bounds));
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) { }];
        }
            
            break;
            
        case SlideLeft:{
            self.transform = CGAffineTransformMakeTranslation(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self
                .transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) { }];
        }
            
            break;
            
        case SlideRight:{
            self.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth([UIScreen mainScreen].bounds), 0);
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) { }];
        }
            
            break;
        case SlideBottom:{
            self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight([UIScreen mainScreen].bounds));
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) { }];
        }
            
            break;
            
            
        case FadeIn:{
            self.alpha = 0;
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.alpha = 1;
            } completion:^(BOOL finished) { }];
        }
            
            break;
            
        case FadeOut:{
            self.alpha = 1;
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.alpha = 0;
            } completion:^(BOOL finished) { }];
        }
            
            break;
            
        case FadeInLeft:{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeTranslation(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.alpha = 1;
                self.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) { }];
            
        }
            
            break;
        case FadeInRight:{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth([UIScreen mainScreen].bounds), 0);
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.alpha = 1;
                self.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) { }];
        }
            
            break;
            
        case FadeInTop:{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight([UIScreen mainScreen].bounds));
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.alpha = 1;
                self.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) { }];
        }
            
            break;
            
        case FadeInBottom:{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight([UIScreen mainScreen].bounds));
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.alpha = 1;
                self.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) { }];
            
        }
            
            break;
            
        case Flash:{
            self.alpha = 0;
            [UIView animateKeyframesWithDuration:Duration/3 delay:Delay options:0 animations:^{
                // End
                self.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:Duration/3 delay:0 options:0 animations:^{
                    // End
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:Duration/3 delay:0 options:0 animations:^{
                        // End
                        self.alpha = 1;
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            }];
            
        }
            
            break;
        case Pop:{
            self.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateKeyframesWithDuration:Duration/3 delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:Duration/3 delay:0 options:0 animations:^{
                    // End
                    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:Duration/3 delay:0 options:0 animations:^{
                        // End
                        self.transform = CGAffineTransformMakeScale(1, 1);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            }];
            
        }
            
            break;
        case Shake:{
            self.transform = CGAffineTransformMakeTranslation(0, 0);
            [UIView animateKeyframesWithDuration:Duration/5 delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeTranslation(30, 0);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:Duration/5 delay:0 options:0 animations:^{
                    // End
                    self.transform = CGAffineTransformMakeTranslation(-30, 0);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:Duration/5 delay:0 options:0 animations:^{
                        // End
                        self.transform = CGAffineTransformMakeTranslation(15, 0);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:Duration/5 delay:0 options:0 animations:^{
                            // End
                            self.transform = CGAffineTransformMakeTranslation(-15, 0);
                        } completion:^(BOOL finished) {
                            [UIView animateKeyframesWithDuration:Duration/5 delay:0 options:0 animations:^{
                                // End
                                self.transform = CGAffineTransformMakeTranslation(0, 0);
                            } completion:^(BOOL finished) {
                                // End
                            }];
                        }];
                    }];
                }];
            }];
            
        }
            
            break;
            
        case ZoomIn:{
            self.transform = CGAffineTransformMakeScale(1, 1);
            self.alpha = 1;
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeScale(2, 2);
                self.alpha = 0;
            } completion:^(BOOL finished) {
                //        view.transform = CGAffineTransformMakeScale(1, 1);
                //        view.alpha = 1;
            }];
        }
            
            break;
            
        case ZoomOut:{
            self.transform = CGAffineTransformMakeScale(2, 2);
            self.alpha = 0;
            [UIView animateKeyframesWithDuration:Duration delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeScale(1, 1);
                self.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
            
            break;
        case Morph:{
            self.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateKeyframesWithDuration:Duration/4 delay:Delay options:0 animations:^{
                // End
                self.transform = CGAffineTransformMakeScale(1, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                    // End
                    self.transform = CGAffineTransformMakeScale(1.2, 0.9);
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                        // End
                        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    } completion:^(BOOL finished) {
                        [UIView animateKeyframesWithDuration:Duration/4 delay:0 options:0 animations:^{
                            // End
                            self.transform = CGAffineTransformMakeScale(1, 1);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
            
        }
            
            
            break;
            
        default:
            break;
    }
}

- (void)pushTransition:(CFTimeInterval)duration view :(UIView *)view withDirection :(State)direction{
    
    CATransition *animation = [CATransition new];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    if(direction == Bottom){
        animation.subtype = kCATransitionFromTop;
    }else if (direction == Top){
        animation.subtype = kCATransitionFromBottom;
    }else if (direction == Right){
        animation.subtype = kCATransitionFromLeft;
    }else if (direction == Left){
        animation.subtype = kCATransitionFromRight;
    }
    
    animation.duration = duration;
    [view.layer addAnimation:animation forKey:kCATransitionPush];
}




@end
