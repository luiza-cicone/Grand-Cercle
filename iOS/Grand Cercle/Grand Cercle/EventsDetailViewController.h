//
//  EventsDetailViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 17/8/13.
//  Copyright (c) 2013 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "Event.h"

@interface EventsDetailViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate> {
    Event *event;
    IBOutlet UIImageView *ivImage;
    IBOutlet UILabel *lTitle;
    IBOutlet UILabel *time;
    IBOutlet UILabel *lLocation;
    IBOutlet UILabel *lAuthor;
    IBOutlet UIWebView *wvContent;
    IBOutlet UILabel *lDate;
    IBOutlet UIView *vAuthorBkgd;
    IBOutlet UIView *vBkgd;
    
}

@property (retain, nonatomic) Event *event;
@property (retain, nonatomic) IBOutlet UIImageView *ivImage;
@property (retain, nonatomic) IBOutlet UILabel *lTitle;
@property (retain, nonatomic) IBOutlet UILabel *lLocation;
@property (retain, nonatomic) IBOutlet UILabel *lAuthor;
@property (retain, nonatomic) IBOutlet UIWebView *wvContent;
@property (retain, nonatomic) IBOutlet UILabel *lDate;
@property (retain, nonatomic) IBOutlet UIView *vAuthorBkgd;
@property (retain, nonatomic) IBOutlet UIView *vBkgd;

@end
