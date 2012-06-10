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
#import "NewsParser.h"
#import "EventsParser.h"
#import "DealsParser.h"
#import "FilterParser.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end



