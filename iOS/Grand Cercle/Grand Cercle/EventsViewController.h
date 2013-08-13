//
//  FirstViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "StyledPageControl.h"

@interface EventsViewController : UIViewController <UIScrollViewDelegate, UITabBarDelegate> {
    
    IBOutlet UIScrollView *scrollView;

    StyledPageControl *pageControl;

    NSMutableArray *viewControllers;

    BOOL pageControlUsed;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) StyledPageControl *pageControl;

- (IBAction)changePage:(id)sender;


@end
