//
//  SecondViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>

@interface DealsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *arrayBonsPlans;
    IBOutlet UITableViewCell *bonsPlansCell;
    NSMutableArray *urlArray;
    TKImageCache *imageCache;
    IBOutlet UITableView *tview;
}

@property (retain, nonatomic) NSMutableArray *arrayBonsPlans, *urlArray;
@property (retain, nonatomic) IBOutlet UITableViewCell *bonsPlansCell;
@property (retain, nonatomic) TKImageCache *imageCache;
@property (retain, nonatomic) IBOutlet UITableView *tview;

@end
