//
//  EventTableViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 30/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import "EventsViewController.h"

@interface EventsTableViewController : UIViewController {
    IBOutlet UITableViewCell *eventCell;
    NSMutableArray *eventArray;
    NSMutableDictionary *eventDico;
    TKImageCache *imageCache, *imageCache2;
    IBOutlet UITableView *tView;
    EventsViewController *superController;

}

@property (retain, nonatomic) IBOutlet UITableViewCell *eventCell;
@property (retain, nonatomic) NSMutableArray *eventArray;
@property (retain, nonatomic) NSMutableDictionary *eventDico;
@property (retain, nonatomic) TKImageCache *imageCache, *imageCache2;
@property (retain, nonatomic) IBOutlet UITableView *tView;
@property (retain, nonatomic) EventsViewController *superController;
@end