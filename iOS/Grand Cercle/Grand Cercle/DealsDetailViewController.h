//
//  DealsDetailViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deals.h"

@interface DealsDetailViewController : UITableViewController <UIWebViewDelegate> {
    Deals* bonPlan;
    IBOutlet UITableViewCell *cellBonPlanTop;
    IBOutlet UITableViewCell *cellBonPlanDescription;
    
    int webViewHeight;

}

@property (retain, nonatomic) Deals *bonPlan;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellBonPlanDescription, *cellBonPlanTop;

@end
