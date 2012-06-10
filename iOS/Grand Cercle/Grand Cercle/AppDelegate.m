//
//  AppDelegate.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activity setFrame:CGRectMake(100, 350, 100, 100)];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.window.frame.size.width, self.window.frame.size.height)];
    [iv setImage:[UIImage imageNamed:@"default.png"]];
    [v addSubview:iv];
    [v addSubview:activity];
    UIViewController *vc  = [[UIViewController alloc] init];
    [vc setView: v];
    self.window.rootViewController = vc;

    [self.window makeKeyAndVisible];

    [activity startAnimating];
    
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.grandcercle.org"];
    
    // here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification 
                                               object:nil];
    
    [reach startNotifier];

    
    return YES;
}

- (void)startParse {
    
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
    
    UIViewController *viewController4 = [[[InfosViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController *navigationController4 = [[UINavigationController alloc] init];
    navigationController4.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController4.viewControllers = [NSArray arrayWithObjects:viewController4, nil];
    
    UIViewController *viewController5 = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    UINavigationController *navigationController5 = [[UINavigationController alloc] init];
    navigationController5.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController5.viewControllers = [NSArray arrayWithObjects:viewController5, nil];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController1, navigationController2, navigationController3, navigationController4, navigationController5, nil];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([reach isReachable]) {

        // On parse les associations
        FilterParser *ap = [FilterParser instance];
        [ap loadStuffFromURL];
        
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
            
            NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] init];
            for (NSString *type in [ap arrayTypes]) {
                [typesDico setValue:[NSNumber numberWithBool:YES] forKey:type];
            }
            [defaults setObject:typesDico forKey:@"filtreTypes"];
            
            NSArray *colorArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
            [defaults setObject:colorArray forKey:@"theme"];
            
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // On parse les événements
        EventsParser *ep = [EventsParser instance];
        [ep loadEventsFromURL];
        
        // On parse les news
        NewsParser *np = [NewsParser instance];
        [np loadNewsFromURL];
        
        // On parse les bons plans
        DealsParser *bp = [DealsParser instance];
        [bp loadDealsFromURL];

    }
    else
    {
        
        // On parse les associations
        FilterParser *ap = [FilterParser instance];
        [ap loadStuffFromFile];
        
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
            
            NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] init];
            for (NSString *type in [ap arrayTypes]) {
                [typesDico setValue:[NSNumber numberWithBool:YES] forKey:type];
            }
            [defaults setObject:typesDico forKey:@"filtreTypes"];
            
            NSArray *colorArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
            [defaults setObject:colorArray forKey:@"theme"];
            
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // On parse les événements
        EventsParser *ep = [EventsParser instance];
        [ep loadEventsFromFile];
        
        // On parse les news
        NewsParser *np = [NewsParser instance];
        [np loadNewsFromFile];
        
        // On parse les bons plans
        DealsParser *bp = [DealsParser instance];
        [bp loadDealsFromFile];

    }
    
    [self performSelector:@selector(startParse) withObject:nil afterDelay:0.01];
    [reach stopNotifier];
}

/***************
 * Destructeur *
 **************/
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

@end
