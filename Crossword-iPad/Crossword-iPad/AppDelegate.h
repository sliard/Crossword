//
//  AppDelegate.h
//  puzzleipad
//
//  Created by Samuel Liard on 17/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

@end
