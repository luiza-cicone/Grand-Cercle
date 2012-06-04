//
//  AppDelegate.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "AppDelegate.h"

#import "EventsViewController.h"
#import "NewsViewController.h"
#import "DealsViewController.h"
#import "InfosViewController.h"
#import "SettingsViewController.h"

#import "NewsParser.h"
#import "EvenementsParser.h"
#import "BonsPlansParser.h"

#import "FilterParser.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    
    // On parse les associations
    FilterParser *ap = [FilterParser instance];
    [ap loadAssociations];
    
    if (![defaults objectForKey:@"firstRun"]) {
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
        NSMutableDictionary *cerclesDico = [[NSMutableDictionary alloc] init];
        for (NSString *cercle in [ap arrayCercles]) {
            [cerclesDico setValue:[NSNumber numberWithBool:YES] forKey:cercle];
        }
        [defaults setObject:cerclesDico forKey:@"filtreCercles"];
        
        NSMutableDictionary *clubsDico = [[NSMutableDictionary alloc] init];
        for (NSString *clubs in [ap arrayClubs]) {
            [clubsDico setValue:[NSNumber numberWithBool:YES] forKey:clubs];
        }
        [defaults setObject:clubsDico forKey:@"filtreClubs"];
        
        NSMutableDictionary *filtresDico = [[NSMutableDictionary alloc] init];
        for (NSString *type in [ap arrayTypes]) {
            [filtresDico setValue:[NSNumber numberWithBool:YES] forKey:type];
        }
        [defaults setObject:clubsDico forKey:@"filtreClubs"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    // On parse les événements
    EvenementsParser *ep = [EvenementsParser instance];
    [ep loadEvenements];
    
    // On parse les news
    NewsParser *np = [NewsParser instance];
    [np loadNews];
    
    // On parse les bons plans
    BonsPlansParser *bp = [BonsPlansParser instance];
    [bp loadBonsPlans];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    UINavigationController *navigationController1 = [[UINavigationController alloc] init];
    UIViewController *viewController1 = [[[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil] autorelease];
    navigationController1.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController1.viewControllers = [NSArray arrayWithObjects:viewController1, nil];

    UIViewController *viewController2 = [[[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil] autorelease];
    UINavigationController *navigationController2 = [[UINavigationController alloc] init];
    navigationController2.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController2.viewControllers = [NSArray arrayWithObjects:viewController2, nil];
    
    UIViewController *viewController3 = [[[DealsViewController alloc] initWithNibName:@"DealsViewController" bundle:nil] autorelease];
    UINavigationController *navigationController3 = [[UINavigationController alloc] init];
    navigationController3.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController3.viewControllers = [NSArray arrayWithObjects:viewController3, nil];
    
    UIViewController *viewController4 = [[[InfosViewController alloc] initWithNibName:@"InfosViewController" bundle:nil] autorelease];
    UINavigationController *navigationController4 = [[UINavigationController alloc] init];
    navigationController4.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController4.viewControllers = [NSArray arrayWithObjects:viewController4, nil];
    
    UIViewController *viewController5 = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    UINavigationController *navigationController5 = [[UINavigationController alloc] init];
    navigationController5.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController5.viewControllers = [NSArray arrayWithObjects:viewController5, nil];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController1, navigationController2, navigationController3, navigationController4, navigationController5, nil];
//    [navigationController2 release]; navigationController2 = nil;
//    [navigationController1 release]; navigationController1 = nil;
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
