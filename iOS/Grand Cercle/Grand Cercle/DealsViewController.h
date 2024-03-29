//
//  SecondViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealsParser.h"
#import "DealDetailViewController.h"

@interface DealsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    // Tableau contenant les bons plans
    NSMutableArray *arrayDeals;
    
    // La cellule customize
    IBOutlet UITableViewCell *dealsCell;
        
    // Table view des bons plans
    IBOutlet UITableView *tview;
    
    NSManagedObjectContext *managedObjectContext;

}

@property (retain, nonatomic) NSArray *arrayDeals;
@property (retain, nonatomic) IBOutlet UITableViewCell *dealsCell;
@property (retain, nonatomic) IBOutlet UITableView *tview;

@end