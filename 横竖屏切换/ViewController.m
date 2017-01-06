//
//  ViewController.m
//  横竖屏切换
//
//  Created by siping ruan on 17/1/3.
//  Copyright © 2017年 Rasping. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()<SecondViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *testView;
- (IBAction)fullBtnClicked:(UIButton *)btn;
@property (strong, nonatomic) SecondViewController *secondVC;

@end

@implementation ViewController

#pragma mark - Initial

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //View controller-based status bar appearance
    //YES 则控制器对状态栏设置的优先级高于application
    //NO 则以application为准，控制器设置状态栏prefersStatusBarHidden是无效的的根本不会被调用
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //监听手动切换横竖屏状态
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)deviceOrientationDidChange
{
    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self orientationChange:UIInterfaceOrientationPortrait];
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self orientationChange:UIInterfaceOrientationLandscapeLeft];
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self orientationChange:UIInterfaceOrientationLandscapeRight];
    }
}

- (void)orientationChange:(UIInterfaceOrientation)rotation
{
    switch (rotation) {
        case UIInterfaceOrientationPortrait:
            [self dismissVC];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self presentVC:UIInterfaceOrientationLandscapeRight];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self presentVC:UIInterfaceOrientationLandscapeLeft];
            break;
            
        default:
            break;
    }
}

#pragma mark - Private

- (void)presentVC:(UIInterfaceOrientation)orientation
{
    if (!self.secondVC) {
        SecondViewController *secondVC = [[SecondViewController alloc] init];
        secondVC.delegate = self;
        secondVC.orientation = orientation;
        self.secondVC = secondVC;
        [self presentViewController:secondVC animated:NO completion:nil];
    }
}

- (void)dismissVC
{
    if (self.secondVC) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        basicAnimation.fromValue = @(M_PI_4);
        if (self.secondVC.orientation == UIInterfaceOrientationLandscapeLeft) {
            basicAnimation.fromValue = @(-M_PI_4);
        }
        basicAnimation.toValue = @(0);
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.fillMode = kCAFillModeForwards;
        [self.testView.layer addAnimation:basicAnimation forKey:nil];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        self.secondVC = nil;
    }
}

#pragma mark - UIViewControllerRotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Action

- (IBAction)fullBtnClicked:(UIButton *)btn
{
    [self presentVC:UIInterfaceOrientationLandscapeRight];
}

#pragma mark - SecondViewControllerDelegate

- (void)secondViewController:(SecondViewController *)secondVC btnClicked:(UIButton *)btn
{
    [self dismissVC];
}

@end
