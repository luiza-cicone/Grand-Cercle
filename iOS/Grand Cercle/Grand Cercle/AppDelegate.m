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
@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator; 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
   
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.window.frame.size.width, self.window.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"default.png"]];
    [view addSubview:imageView];
    [imageView release];

    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setFrame:CGRectMake(72, 182, 40, 40)];
    [view addSubview:activityIndicator];
    [activityIndicator release];
    
    UIViewController *vc  = [[UIViewController alloc] init];
    [vc setView: view];
    [view release];
    self.window.rootViewController = vc;
    [vc release];
    [self.window makeKeyAndVisible];

    [activityIndicator startAnimating];
    
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
    UINavigationController *navigationController1 = [[[UINavigationController alloc] init] autorelease];
    UIViewController *viewController1 = [[[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil] autorelease];
    navigationController1.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController1.viewControllers = [NSArray arrayWithObjects:viewController1, nil];

    UIViewController *viewController2 = [[[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil] autorelease];
    UINavigationController *navigationController2 = [[[UINavigationController alloc] init] autorelease];
    navigationController2.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController2.viewControllers = [NSArray arrayWithObjects:viewController2, nil];

    UIViewController *viewController3 = [[[DealsViewController alloc] initWithNibName:@"DealsViewController" bundle:nil] autorelease];
    UINavigationController *navigationController3 = [[[UINavigationController alloc] init] autorelease];
    navigationController3.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController3.viewControllers = [NSArray arrayWithObjects:viewController3, nil];

    UIViewController *viewController4 = [[[InfosViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController *navigationController4 = [[[UINavigationController alloc] init] autorelease];
    navigationController4.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController4.viewControllers = [NSArray arrayWithObjects:viewController4, nil];
    
    UIViewController *viewController5 = [[[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    UINavigationController *navigationController5 = [[[UINavigationController alloc] init] autorelease];
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
            [cerclesDico release];
            
            NSMutableDictionary *clubsDico = [[NSMutableDictionary alloc] init];
            for (NSString *clubs in [ap arrayClubs]) {
                [clubsDico setValue:[NSNumber numberWithBool:YES] forKey:clubs];
            }
            [defaults setObject:clubsDico forKey:@"filtreClubs"];
            [clubsDico release];
            
            NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] init];
            for (NSString *type in [ap arrayTypes]) {
                [typesDico setValue:[NSNumber numberWithBool:YES] forKey:type];
            }
            [defaults setObject:typesDico forKey:@"filtreTypes"];
            [typesDico release];
            NSArray *colorArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
            [defaults setObject:colorArray forKey:@"theme"];
            [colorArray release];
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
            [cerclesDico release];
            
            NSMutableDictionary *clubsDico = [[NSMutableDictionary alloc] init];
            for (NSString *clubs in [ap arrayClubs]) {
                [clubsDico setValue:[NSNumber numberWithBool:YES] forKey:clubs];
            }
            [defaults setObject:clubsDico forKey:@"filtreClubs"];
            [clubsDico release];
            
            NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] init];
            for (NSString *type in [ap arrayTypes]) {
                [typesDico setValue:[NSNumber numberWithBool:YES] forKey:type];
            }
            [defaults setObject:typesDico forKey:@"filtreTypes"];
            [typesDico release];
            
            NSArray *colorArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
            [defaults setObject:colorArray forKey:@"theme"];
            [colorArray release];
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

#pragma mark - CORE DATA

//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"Data.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [super dealloc];
}

@end
