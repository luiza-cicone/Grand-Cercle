//
//  FirstViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController <UIScrollViewDelegate> {
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    BOOL pageControlUsed;
 
    UINavigationController *myNav;

}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

@property (retain, nonatomic) UINavigationController *myNav;

- (IBAction)changePage:(id)sender;


@end
