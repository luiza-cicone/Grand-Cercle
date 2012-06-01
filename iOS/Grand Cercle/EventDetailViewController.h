//
//  EventDetailViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 31/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Evenements.h"

@interface EventDetailViewController : UITableViewController {
    Evenements *event;
}

@property (retain, nonatomic) Evenements *event;

@end
