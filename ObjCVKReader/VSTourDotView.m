//
//  GSTourDotView.m
//  Geo4ME
//
//  Created by Сергей Веселовский on 28.02.17.
//  Copyright © 2017 GradoService LLC. All rights reserved.
//

#import "VSTourDotView.h"

@implementation VSTourDotView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (void)initialization
{
    self.backgroundColor    = [UIColor clearColor];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    self.layer.borderColor  = [UIColor colorWithRed:255.0/255 green:160.0/255 blue:0.0/255 alpha:1.0].CGColor;
    self.layer.borderWidth  = 1;
}


//- (void)changeActivityState:(BOOL)active
//{
//    if (active) {
//        self.backgroundColor = [UIColor colorWithRed:255.0/255 green:160.0/255 blue:0.0/255 alpha:1.0];
//    } else {
//        self.backgroundColor = [UIColor clearColor];
//    }
//}

- (void)changeActivityState:(BOOL)active
{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDeactiveState];
    }
}


- (void)animateToActiveState
{
    self.backgroundColor = [UIColor colorWithRed:255.0/255 green:160.0/255 blue:0.0/255 alpha:1.0];
    [UIView animateWithDuration: 1 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:nil];
}

- (void)animateToDeactiveState
{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration: 1 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}


@end
