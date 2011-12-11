//
//  AppDelegate.m
//  puzzleipad
//
//  Created by Samuel Liard on 17/11/11.
//  Copyright (c) 2011 Liard. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "FlurryAnalytics.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

#if defined(EN)

    #if defined(LITE)
        [FlurryAnalytics startSession:@"JK5GQNAY7D69CGH41YP2"];
        NSLog(@"Lite EN");
    #else
        [FlurryAnalytics startSession:@"H8RU8YQSNDJ768SYNC6S"];
        NSLog(@" EN");
    #endif

#else
    
    #if defined(LITE)
        [FlurryAnalytics startSession:@"TYICVWTCR8ZDDYJKWFIU"];
    #else
        [FlurryAnalytics startSession:@"8ERVGVF49F98PASNW9CB"];
    #endif

#endif
    
    // EN  H8RU8YQSNDJ768SYNC6S
    
    // EN Free  JK5GQNAY7D69CGH41YP2
    
    /*
     self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
     // Override point for customization after application launch.
     self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
     self.window.rootViewController = self.viewController;
     [self.window makeKeyAndVisible];
     */    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.navController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    
    self.navController.navigationBarHidden = TRUE;
    
    [FlurryAnalytics logAllPageViews:self.navController];
    
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
}

@end
