//
//  DealsDetailViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deals.h"
#import "NSString+HTML.h"

@interface DealsDetailViewController : UITableViewController <UIWebViewDelegate> {
    // Bon plan concernée par le détail view
    Deals* bonPlan;
    // Cellule titre du bon plan
    IBOutlet UITableViewCell *cellBonPlanTop;
    // Cellule description du bon plan
    IBOutlet UITableViewCell *cellBonPlanDescription;
    // Hauteur du cadre de la description du bon plan
    int webViewHeight;
}

@property (retain, nonatomic) Deals *bonPlan;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellBonPlanDescription, *cellBonPlanTop;

@end
