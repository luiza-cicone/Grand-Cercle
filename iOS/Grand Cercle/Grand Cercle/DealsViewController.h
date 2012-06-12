//
//  SecondViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import "DealsParser.h"
#import "DealsDetailViewController.h"

@interface DealsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    // Tableau contenant les bons plans
    NSMutableArray *arrayBonsPlans;
    // Cellule de la liste des bons plans
    IBOutlet UITableViewCell *bonsPlansCell;
    // Tableau contenant les url des images
    NSMutableArray *urlArray;
    // Cache
    TKImageCache *imageCache;
    // Table view des bons plans
    IBOutlet UITableView *tview;
}

@property (retain, nonatomic) NSMutableArray *arrayBonsPlans, *urlArray;
@property (retain, nonatomic) IBOutlet UITableViewCell *bonsPlansCell;
@property (retain, nonatomic) TKImageCache *imageCache;
@property (retain, nonatomic) IBOutlet UITableView *tview;

@end