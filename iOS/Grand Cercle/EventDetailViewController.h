//
//  EventDetailViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 31/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "Events.h"

@interface EventDetailViewController : UITableViewController <UIActionSheetDelegate, UIWebViewDelegate> {
    Events *event;
    IBOutlet UITableViewCell *cellEventDescription;
    IBOutlet UITableViewCell *cellEventTop;
    IBOutlet UITableViewCell *cellEventInfo;
    
    int webViewHeight;
}

@property (retain, nonatomic) Events *event;
@property (retain, nonatomic) IBOutlet UITableViewCell *cellEventTop, *cellEventDescription, *cellEventInfo;

@end
