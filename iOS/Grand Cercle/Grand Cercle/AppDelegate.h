//
//  AppDelegate.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsViewController.h"
#import "NewsViewController.h"
#import "DealsViewController.h"
#import "InfosViewController.h"
#import "SettingsViewController.h"
#import "AssociationParser.h"
#import "NewsParser.h"
#import "EventsParser.h"
#import "DealsParser.h"
#import "FilterParser.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    NSArray *arrayCercles;
    NSArray *arrayClubs;
    NSArray *arrayTypes;
    IBOutlet UIView *helperView;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain, nonatomic) IBOutlet UIView *helperView;

- (IBAction)closeHelperView:(id)sender;
- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;
- (void)initializeOnFirstRun;

- (UIColor*)colorWithHexString:(NSString*)hex;
@end



