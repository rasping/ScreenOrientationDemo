//
//  SecondViewController.h
//  横竖屏切换
//
//  Created by siping ruan on 17/1/4.
//  Copyright © 2017年 Rasping. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SecondViewController;
@protocol SecondViewControllerDelegate <NSObject>

@optional
- (void)secondViewController:(SecondViewController *)secondVC btnClicked:(UIButton *)btn;

@end

@interface SecondViewController : UIViewController

@property (weak, nonatomic) id<SecondViewControllerDelegate> delegate;
/**
 屏幕旋转方向
 */
@property (assign, nonatomic)UIInterfaceOrientation orientation;

@end
