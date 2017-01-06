//
//  SecondViewController.m
//  横竖屏切换
//
//  Created by siping ruan on 17/1/4.
//  Copyright © 2017年 Rasping. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

- (IBAction)btnClicked:(UIButton *)btn;

@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue = @(-M_PI_4);
    basicAnimation.toValue = @(0);
    basicAnimation.removedOnCompletion = YES;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.view.layer addAnimation:basicAnimation forKey:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - UIViewControllerRotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.orientation;
}

#pragma mark - Action

- (IBAction)btnClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(secondViewController:btnClicked:)]) {
        [self.delegate secondViewController:self btnClicked:btn];
    }
}

@end
