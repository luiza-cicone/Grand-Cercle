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

    IBOutlet UILabel *titleLabel, *dateLabel, *placeLabel;
    IBOutlet UIImageView *eventImageView;
}

@property (retain, nonatomic) Event *event;
@property (retain, nonatomic) EventsViewController *superController;
@property (retain, nonatomic) TKImageCache *imageCache;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel, *dateLabel, *placeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *eventImageView;


- (IBAction)imageButtonAction:(id)sender;
-(void) loadData;
@end
