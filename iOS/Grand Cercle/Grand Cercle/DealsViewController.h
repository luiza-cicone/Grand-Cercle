//
//  SecondViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *arrayBonsPlans;
    IBOutlet UITableViewCell *bonsPlansCell;
}

@property (retain, nonatomic) NSMutableArray *arrayBonsPlans;
@property (retain, nonatomic) IBOutlet UITableViewCell *bonsPlansCell;

@end
