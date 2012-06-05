//
//  SettingsDetailViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsDetailViewController : UITableViewController {
    NSArray *clubsArray, *cerclesArray, *typesArray, *themesArray;
    NSMutableArray *clubsChoice, *cerclesChoice, *typesChoice;
    UIColor *themeChoice;
    NSIndexPath *filter;
}

@property (nonatomic, retain) NSArray *clubsArray, *cerclesArray, *typesArray, *themesArray;
@property (nonatomic, retain) NSMutableArray *clubsChoice, *cerclesChoice, *typesChoice;
@property (nonatomic, retain) NSIndexPath *filter;
@property (nonatomic, retain) UIColor *themeChoice;

@end
