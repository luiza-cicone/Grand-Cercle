//
//  AppDelegate.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "AppDelegate.h"
#import "Association.h"
#import "UIImage+568h.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator; 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
   
    // set the background image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:@"Default"]];
    [view addSubview:imageView];
    [imageView release];

    // set the activity indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.window.frame.size.width/2-68, self.window.frame.size.height/2-18);
    [view addSubview:activityIndicator];
    [activityIndicator release];
    
    UIViewController *vc  = [[UIViewController alloc] init];
    [vc setView: view];
    [view release];
    self.window.rootViewController = vc;
    [vc release];
    [self.window makeKeyAndVisible];

    [activityIndicator startAnimating];
    
    
    // how we stop refresh from freezing the main UI thread
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults objectForKey:@"firstRun"]) {
            NSLog(@"initialize on first run");
            [self initializeOnFirstRun];
        }

        // do any UI stuff on the main UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(startApp) withObject:nil afterDelay:0.01];
        });

    });
    dispatch_release(downloadQueue);
        
//    // allocate a reachability object
//    Reachability* reach = [Reachability reachabilityWithHostname:@"www.grandcercle.org"];
//    
//    // here we set up a NSNotification observer. The Reachability that caused the notification
//    // is passed in the object parameter
//    [[NSNotificationCenter defaultCenter] addObserver:self 
//                                             selector:@selector(reachabilityChanged:) 
//                                                 name:kReachabilityChangedNotification 
//                                               object:nil];
//    
//    [reach startNotifier];

    
    return YES;
}

- (void)startApp {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

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
    UINavigationController *navigationController5 = [[[UINavigationController alloc] init] autorelease];
    navigationController5.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigationController5.viewControllers = [NSArray arrayWithObjects:viewController5, nil];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];

    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController1, navigationController2, navigationController3, navigationController4, navigationController5, nil];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}

-(void)initializeOnFirstRun
{
    
    [[AssociationParser instance] loadFromFile];
    [[FilterParser instance] loadFromFile];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"firstRun"];

    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    NSEntityDescription *assosEntity = [NSEntityDescription entityForName:@"Association" inManagedObjectContext:managedObjectContext]; 
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
            
    // filtre des cercles
    NSPredicate *ofIdPredicate = [NSPredicate predicateWithFormat:@"(type = %d) AND NOT (name = 'Grand Cercle')", 1];
    [request setEntity:assosEntity];
    [request setPredicate:ofIdPredicate];        
    
    NSError *error = nil;
    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil && error == nil) {
        arrayCercles = array;
        [arrayCercles retain];
    }
    else {
        // Deal with error.
    }
    [request release];
    
    
    NSMutableDictionary *cerclesDico = [[NSMutableDictionary alloc] init];
    for (Association *cercle in arrayCercles) {
        FilterParser *ap = [FilterParser instance];
        arrayTypes = [ap arrayTypes];
        
        NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] init];
        for (NSString *type in arrayTypes) {
            [typesDico setValue:[NSNumber numberWithBool:YES] forKey:type];
        }
        [cerclesDico setValue:typesDico forKey:[cercle name]];
        [typesDico release];
    }
    [defaults setObject:cerclesDico forKey:@"filtreCercles"];
    [cerclesDico release];
    
    
    // filter des clubs
    request = [[NSFetchRequest alloc] init]; 
    
    ofIdPredicate = [NSPredicate predicateWithFormat:@"(type = %d) AND NOT (name = 'Elus étudiants')", 2];

    [request setEntity:assosEntity];
    [request setPredicate:ofIdPredicate];        
    
    error = nil;
    
    array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil && error == nil) {
        arrayClubs = array;
        [arrayClubs retain];
    }
    else {
        // Deal with error.
    }
    [request release];
        
    NSMutableDictionary *clubsDico = [[NSMutableDictionary alloc] init];
    for (Association *clubs in arrayClubs) {
        [clubsDico setValue:[NSNumber numberWithBool:YES] forKey:[clubs name]];
    }
    [defaults setObject:clubsDico forKey:@"filtreClubs"];
    [clubsDico release];
    

    // filter color
    NSArray *colorArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
    [defaults setObject:colorArray forKey:@"theme"];
    [colorArray release];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NewsParser instance] loadFromFile];
    NSLog(@"News loaded");
    [[EventsParser instance] loadFromFile];
    NSLog(@"Events loaded");
    [[DealsParser instance] loadFromFile];
    NSLog(@"Deals loaded");

}

-(void)reachabilityChanged:(NSNotification*) notification
{
    Reachability * reach = [notification object];

    if([reach isReachable]) {
        
        NSLog(@"Rechability changed : now reachable");

//        // On parse les types
//        [[FilterParser instance] loadFromURL];
//        [[AssociationParser instance] loadFromURL];
//        
//        // puis les cercles et clubs
//        if (![defaults objectForKey:@"firstRun"]) {
//            [self initializeOnFirstRun];
//        }
        
//        [[EventsParser instance] loadFromURL];
//        [[NewsParser instance] loadFromURL];
//        [[DealsParser instance] loadFromURL];

    }
    else {
        NSLog(@"Rechability changed : now NOT reachable");

//        FilterParser *ap = [FilterParser instance];
//        [ap loadFromFile];
//        
//        if (![defaults objectForKey:@"firstRun"]) {
//            AssociationParser *assos = [AssociationParser instance];
//            [assos loadFromFile];
//            
//            [self initializeOnFirstRun];
//        }
    }
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"foreground");
    [self update];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"active");
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Data" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    

    return managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Data.sqlite"]];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle error
    }    
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)saveContext
{
    NSError *error = nil;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}
#pragma mark - Object classes
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [super dealloc];
}

- (void) update
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        
        [[EventsParser instance] loadFromURL];
        [[NewsParser instance] loadFromURL];
        [[DealsParser instance] loadFromURL];
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            NSLog(@"Update finished");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFinished" object:nil];
        });
    });
}

@end
