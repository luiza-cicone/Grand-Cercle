//
//  EventFourNextViewController.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsViewController.h"
#import <TapkuLibrary/TapkuLibrary.h>

@interface EventFourNextViewController : UIViewController {
    EventsViewController *superController;
    
    TKImageCache *imageCache;
    NSMutableArray *arrayEvents;
    
    NSManagedObjectContext *managedObjectContext;
}

@property (retain, nonatomic) NSMutableArray *arrayEvents;
@property (retain, nonatomic) EventsViewController *superController;
@property (retain, nonatomic) TKImageCache *imageCache;

- (IBAction)imageButtonAction:(id)sender;
-(void) loadData;
@end
