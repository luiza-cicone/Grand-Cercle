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
#import "AssociationParser.h"
#import "Reachability.h"

@interface EventsViewController ()

@end

@implementation EventsViewController
@synthesize viewControllers, scrollView;
@synthesize pageControl = _pageControl;

int kNumberOfPages = 3;

#pragma mark - View Functions

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"Events", @"Evenements");
        self.tabBarItem.image = [UIImage imageNamed:@"calendar_icon"];
        
        // initialisation du page control
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectZero];
        [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        CGFloat tabBarHeight = 49;
        CGFloat navBarHeight = 44;
        CGFloat statusBarHeight = 20;
    
        CGFloat pageControlHeight = 20;
        
        CGFloat posY = screenHeight - statusBarHeight - navBarHeight - tabBarHeight - pageControlHeight;

        [_pageControl setFrame:CGRectMake(0, posY , screenWidth, pageControlHeight)];
        [self.view addSubview:_pageControl];
        
        // listen to notifications to update views
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadEventsData:) name:@"updateFinished" object:nil];

    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft && interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // initialisation de l'array des controllers
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // mise en place du scroll view
    scrollView.pagingEnabled = YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;

    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, screenHeight-kTabBarHeight-kNavBarHeight-kStatusBarHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    // mise en place du page control
    [_pageControl setPageControlStyle:PageControlStyleDefault]; 
    
    [_pageControl setGapWidth:5];
    [_pageControl setDiameter:9];
    
    [_pageControl setNumberOfPages:kNumberOfPages];
    [_pageControl setCurrentPage:1];
    [self changePage:nil];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    // initialise les 3 pages
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
        
    // Reload issues button
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = button;
    [button release];
    
    //mise en place du boutton de retour
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Retour" 
                                                                   style: UIBarButtonItemStylePlain 
                                                                  target: nil 
                                                                  action: nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];

}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *c = [defaults objectForKey:@"theme"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_pageControl release];
    _pageControl = nil;
    
    [viewControllers release];
    viewControllers = nil;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{

    if (pageControlUsed) {
        return;
    }
    // calcule la nouvelle page
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    [_pageControl setCurrentPage:page];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

#pragma mark - Paginf


- (IBAction)changePage:(id)sender
{

    int page = _pageControl.currentPage;
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    // initialise l'array des controlleurs pour les 3 subviews
    UIViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        if (page == 0) {
            controller = [[EventsTableViewController alloc] initWithNibName:@"EventsTableViewController" bundle:nil];
            [(EventsTableViewController *)controller setSuperController: self];
            [viewControllers replaceObjectAtIndex:page withObject:controller];
            [controller release];
        }
        else if (page == 2){
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
    
    // inititalisation du scroll view a la bonne taille
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

#pragma mark - Update

- (IBAction)refresh:(id)sender
{
    BOOL canUpdate = [[Reachability reachabilityWithHostname:@"www.grandcercle.org"] isReachable];
    
    if (canUpdate) {
        
        // replace right bar button 'refresh' with spinner
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-10);
        spinner.hidesWhenStopped = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.view.frame.size.height/2, self.view.frame.size.width, 60)];
        [label setText:@"Chargement de mises à jour"];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        [label setTextAlignment:UITextAlignmentCenter];
        
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rectangle"]];
        iv.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        
        
        UIView *v = [[UIView alloc]initWithFrame:self.view.frame];
        [v setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        [v addSubview:iv];
        [iv release];
        [v addSubview:spinner];
        [spinner release];
        [v addSubview:label];
        [label release];
        
        [self.view addSubview:v];
        [v release];
        [spinner startAnimating];
        [scrollView setUserInteractionEnabled:FALSE];
        
        // how we stop refresh from freezing the main UI thread
        dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            // do our long running process here
            // On parse les événements
            [[AssociationParser instance] loadFromURL];
            [[EventsParser instance] loadFromURL];
            
            // do any UI stuff on the main UI thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [v removeFromSuperview];
                [scrollView setUserInteractionEnabled:TRUE];
                            
                [((EventFourNextViewController *)[viewControllers objectAtIndex:1]) loadData];
                [((EventsCalendarViewController *)[viewControllers objectAtIndex:2])reloadData];
                [((EventsTableViewController *)[viewControllers objectAtIndex:0]) loadData];
            });
            
        });
        dispatch_release(downloadQueue);
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pas de connexion internet"
                                                        message:@"Vous devez vous connecter à internet pour avoir les mises à jour."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void) reloadEventsData: (NSNotification *) notification {
    NSLog(@"%@", [NSString stringWithFormat: @"EventsViewControler : notification %@ received", notification.name]);

    if ([[notification name] isEqualToString:@"updateFinished"]){
        
        [((EventFourNextViewController *)[viewControllers objectAtIndex:1]) loadData];
        [((EventsCalendarViewController *)[viewControllers objectAtIndex:2])reloadData];
        [((EventsTableViewController *)[viewControllers objectAtIndex:0]) loadData];

    }
}


@end
