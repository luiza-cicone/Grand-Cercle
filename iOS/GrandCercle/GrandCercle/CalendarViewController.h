//
//  FirstViewController.h
//  GrandCercle
//
//  Created by Luiza Cicone on 22/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *sv;
}
@property (nonatomic, retain) IBOutlet UIScrollView *sv;
@property (nonatomic, retain) IBOutlet UIPageControl *laPage;

- (IBAction)changePage:(id)sender;

@end
