//
//  DealsDetailViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonsPlans.h"

@interface DealsDetailViewController : UITableViewController {
    BonsPlans* bonPlan;
    IBOutlet UITableViewCell *cellBonPlanTop;
    IBOutlet UITableViewCell *cellBonPlanDescription;
}

@property (retain, nonatomic) BonsPlans *bonPlan;
@property (retain, nonatomic)     IBOutlet UITableViewCell *cellBonPlanDescription, *cellBonPlanTop;

@end
