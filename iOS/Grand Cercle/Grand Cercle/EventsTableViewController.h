//
//  EventTableViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 30/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewController : UITableViewController {
    IBOutlet UITableViewCell *eventCell;
    NSMutableArray *eventArray;
    NSMutableDictionary *eventDico;

}

@property (retain, nonatomic) IBOutlet UITableViewCell *eventCell;
@property (retain, nonatomic) NSMutableArray *eventArray;
@property (retain, nonatomic) NSMutableDictionary *dico;

@end