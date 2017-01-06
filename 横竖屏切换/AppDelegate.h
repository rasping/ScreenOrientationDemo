//
//  AppDelegate.h
//  横竖屏切换
//
//  Created by siping ruan on 17/1/3.
//  Copyright © 2017年 Rasping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

