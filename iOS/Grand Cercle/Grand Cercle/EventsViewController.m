//
//  FirstViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsCalendarViewController.h"
#import "EventsTableViewController.h"
#import "EventFourNextViewController.h"

#import "EventsParser.h"

@interface EventsViewController ()

@end

@implementation EventsViewController
@synthesize viewControllers, scrollView, myNav;
@synthesize pageControl = _pageControl;

int kNumberOfPages = 3;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Events", @"Evenements");
        self.tabBarItem.image = [UIImage imageNamed:@"events"];
        
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectZero];
        [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_pageControl setFrame:CGRectMake(0, 350, 320, 20)];

        [self.view addSubview:_pageControl];

    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    if ([[defaults objectForKey:@"changedEvents"] boolValue] == 1) {
        [self viewDidUnload];

        [self viewDidLoad];
        [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"changedEvents"];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"reloadEvents"];
    }
    
    
//[[self.tabBarController tabBar] setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:.18]]; 
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}

-(void)viewDidDisappear:(BOOL)animated {
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft && interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Scroll View

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");

    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    [_pageControl setPageControlStyle:PageControlStyleDefault]; 
    // change gap width
    [_pageControl setGapWidth:5];
    // change diameter
    [_pageControl setDiameter:9];
    
    
    [_pageControl setNumberOfPages:kNumberOfPages];
    [_pageControl setCurrentPage:0];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
        
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];

}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    UIViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        if (page == 2) {
            controller = [[EventsTableViewController alloc] initWithNibName:@"EventsTableViewController" bundle:nil];
            [(EventsTableViewController *)controller setSuperController: self];
            [viewControllers replaceObjectAtIndex:page withObject:controller];
            [controller release];
        }
        else if (page == 1){
            controller = [[EventsCalendarViewController alloc] init];
            [(EventsCalendarViewController *)controller setSuperController:self];
            [viewControllers replaceObjectAtIndex:page withObject:controller];
            [controller release];
        }
        else {
            controller = [[EventFourNextViewController alloc] initWithNibName:@"EventFourNextViewController" bundle:nil];
            [(EventFourNextViewController *)controller setSuperController: self];
            [viewControllers replaceObjectAtIndex:page withObject:controller];
            [controller release];
        }

    }
    
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {

    if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    

    [_pageControl setCurrentPage:page];
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {

    int page = _pageControl.currentPage;
   
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}

@end
