//
//  SettingsDetailViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsDetailViewController : UITableViewController {
    NSArray *clubsArray, *cerclesArray, *typeArray;
    NSArray *clubsChoice, *cerclesChoice;
    NSInteger filter;
}

@property (nonatomic, retain) NSArray *clubsArray, *cerclesArray, *typeArray;
@property (nonatomic, retain) NSArray *clubsChoice, *cerclesChoice;
@property (nonatomic, assign) NSInteger filter;

@end
