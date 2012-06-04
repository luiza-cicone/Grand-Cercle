//
//  EventFourNextViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsViewController.h"

@interface EventFourNextViewController : UIViewController {
    NSMutableArray *tabImage;
    NSMutableArray *tabLabel;
    EventsViewController *superController;
}

@property (retain, nonatomic) NSMutableArray *tabLabel, *tabImage;
@property (retain, nonatomic) EventsViewController *superController;

- (IBAction)imageButtonAction:(id)sender;

@end
