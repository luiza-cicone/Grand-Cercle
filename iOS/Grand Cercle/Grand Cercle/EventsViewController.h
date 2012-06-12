//
//  FirstViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

@interface EventsViewController : UIViewController <UIScrollViewDelegate, UITabBarDelegate> {
    
    IBOutlet UIScrollView *scrollView;
    // le page control customize
    StyledPageControl *pageControl;
    // l'array avec les 3 view controllers
    NSMutableArray *viewControllers;
    // variable booleene pour voir si le page control a ete utilise
    BOOL pageControlUsed;    
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) StyledPageControl *pageControl;

- (IBAction)changePage:(id)sender;


@end
