//
//  FirstViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableViewCell *eventCell;
    NSMutableArray *eventArray;
    NSMutableDictionary *dico;
}

@property (retain, nonatomic) IBOutlet UITableViewCell *eventCell;
@property (retain, nonatomic) NSMutableArray *eventArray;
@property (retain, nonatomic) NSMutableDictionary *dico;

@end
