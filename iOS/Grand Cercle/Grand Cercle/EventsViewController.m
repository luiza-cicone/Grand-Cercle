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
@synthesize viewControllers, scrollView;
@synthesize pageControl = _pageControl;

// constante pour le nombre des pages
int kNumberOfPages = 3;

#pragma mark - View Functions
/****************************
 * Initialisation de la vue *
 ***************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Events", @"Evenements");
        self.tabBarItem.image = [UIImage imageNamed:@"events"];
        
        // initialisation du page control
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectZero];
        [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_pageControl setFrame:CGRectMake(0, 350, 320, 20)];
        [self.view addSubview:_pageControl];

    }
    return self;
}

/************************
 * Chargement de la vue *
 ***********************/
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
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    // mise en place du page control
    [_pageControl setPageControlStyle:PageControlStyleDefault]; 
    
    [_pageControl setGapWidth:5];
    [_pageControl setDiameter:9];
    
    [_pageControl setNumberOfPages:kNumberOfPages];
    [_pageControl setCurrentPage:0];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    // initialise les 3 pages
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
        
    //mise en place du boutton de retour
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Retour" 
                                                                   style: UIBarButtonItemStylePlain 
                                                                  target: nil 
                                                                  action: nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];

}

/************************************************
 * Action réalisée après l'apparition de la vue *
 ***********************************************/
-(void)viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}

/**************************
 * Déchargement de la vue *
 *************************/
- (void)viewDidUnload
{
    [super viewDidUnload];
    [_pageControl release];
    _pageControl = nil;
    
    [viewControllers release];
    viewControllers = nil;
}

/********************************
 * Deallocation du controllerur *
 *******************************/
- (void)dealloc {
    [super dealloc];
}
#pragma mark - Scroll View Delegate

/************************************************************
 * Fonction appelle quand il y a le mouvement sur le scroll *
 ***********************************************************/
- (void)scrollViewDidScroll:(UIScrollView *)sender {

    if (pageControlUsed) {
        return;
    }
    // calcule la nouvelle page
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    [_pageControl setCurrentPage:page];

}

/***************************************
 * Fonction appelle a la fin du scroll *
 ***************************************/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

#pragma mark - Fonctions pour les pages

/*****************************************
 * Change la page si il y a un mouvement * 
 * ou si on a cliqué sur le page control *
 ****************************************/

- (IBAction)changePage:(id)sender {

    int page = _pageControl.currentPage;
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}


/************************************************************
 * Initialise le scroll view avec les controllers des pages *
 ***********************************************************/

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    // initialise l'array des controlleurs pour les 3 subviews
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
    
    // inititalisation du scroll view a la bonne taille
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

@end
