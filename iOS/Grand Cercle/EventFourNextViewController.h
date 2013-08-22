//
//  EventFourNextViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsViewController.h"
#import "Event.h"
#import "TapkuLibrary/TapkuLibrary.h"

@interface EventFourNextViewController : UIViewController {
    EventsViewController *superController;
    Event *event;
    
    NSManagedObjectContext *managedObjectContext;
    
    TKImageCache *imageCache;

    IBOutlet UILabel *titleLabel, *dateLabel,*hourLabel, *placeLabel;
    IBOutlet UIImageView *eventImageView;
    IBOutlet UIImageView *vBkgd;
    IBOutlet UIButton *bDetail;
    IBOutlet UIView *vText;
}
@property (retain, nonatomic) IBOutlet UIImageView *vBkgd;

@property (retain, nonatomic) IBOutlet UIView *vText;
@property (retain, nonatomic) Event *event;
@property (retain, nonatomic) EventsViewController *superController;
@property (retain, nonatomic) TKImageCache *imageCache;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel, *dateLabel,*hourLabel, *placeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *eventImageView;
@property (retain, nonatomic) IBOutlet UIButton *bDetail;


- (IBAction)imageButtonAction:(id)sender;
-(void) loadData;
@end
