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
@property (weak, nonatomic) IBOutlet UINavigationItem *naviBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviBarTop;

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
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.naviBar.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIApplication *application = [UIApplication sharedApplication];
    if (application.statusBarHidden) {
        //显示导航栏
        self.naviBarTop.constant = 0;
        [UIView animateWithDuration:0.65 animations:^{
            [self.view layoutIfNeeded];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        });
    } else {
        //隐藏导航栏
        self.naviBarTop.constant = -64;
        [UIView animateWithDuration:0.65 animations:^{
            [self.view layoutIfNeeded];
        }];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
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

- (void)backBtnClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(secondViewController:btnClicked:)]) {
        [self.delegate secondViewController:self btnClicked:btn];
    }
}

@end
