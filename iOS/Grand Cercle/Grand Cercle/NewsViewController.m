//
//  SecondViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "NewsParser.h"
#import "Association.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation NewsViewController
@synthesize newsCell;
@synthesize tView;
@synthesize newsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (managedObjectContext == nil) { 
            managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        }
        
        // Mise en place du titre
        self.title = NSLocalizedString(@"News", @"News");
        
        // Mise en place de l'image dans l'onglet
        self.tabBarItem.image = [UIImage imageNamed:@"news"];
        
        [self requeryData];
        
        // Mise en place du bouton retour pour la détail view
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [backButton release];
        
        // Reload issues button
        UIBarButtonItem *button = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                   target:self
                                   action:@selector(refreshButtonClicked:)];
        self.navigationItem.rightBarButtonItem = button;
        [button release];
    }
    return self;
}

- (void)requeryData {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idNews" ascending:false];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil && error == nil) {

        [self setNewsArray:array];
        [newsArray retain];
    }
    else {
        NSLog(@"error %@", error);
        // Deal with error.
    }
    [sortDescriptor release];
    [self.tView reloadData];
}

- (IBAction)refreshButtonClicked:(id)sender {
    // test network reachable
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
        [[self view] setUserInteractionEnabled:FALSE];
        
        // how we stop refresh from freezing the main UI thread
        dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            // do our long running process here            
            // On parse les événements
            NewsParser *np = [NewsParser instance];
            [np loadFromURL];
            
            // do any UI stuff on the main UI thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [v removeFromSuperview];
                [[self view] setUserInteractionEnabled:TRUE];
                
                [self requeryData];
                
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


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    // Libération des structures
    [self setNewsCell:nil];
    [newsCell release];
    [newsArray release];
    newsArray = nil;
    newsCell = nil;
    [tView release];
    [super viewDidUnload];
}

- (void)dealloc {
    [newsCell release];
    [newsArray release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {   
    
    // Récupération des préférences utilisateurs
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    // Coloration de la barre du haut avec le bon thème
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
    
    // Si le thème est Grand Cercle, on laisse l'interligne par défaut, sinon on la colore suivant le thème
    UIColor *color;
    if ([[c objectAtIndex:0] floatValue] == 0.0 && [[c objectAtIndex:1] floatValue] == 0.0 && [[c objectAtIndex:2] floatValue] == 0.0) {
        color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.18];
    } else {
        color = [[UIColor alloc] initWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:0.5];
    }
    [self.tView setSeparatorColor:color];
    [color release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = newsCell;
        self.newsCell = nil;
    }
    
    // Définition de la news
    News *news = (News *)[newsArray objectAtIndex:[indexPath row]];
    
    // Affichage de l'image de la news
    UIImageView *imageView = nil;
    
    imageView = (UIImageView *)[cell viewWithTag:1];
    NSString *image;
    
    if (![news.image isEqualToString:@""]) 
        image = news.image;
    else 
        image = news.author.imagePath;
 
    [imageView setImageWithURL:[NSURL URLWithString:image] placeholderImage:nil];

    // Affichage des labels
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    [label setText: [news title]];
    
    label = (UILabel *)[cell viewWithTag:3];
    [label setText:[news pubDate]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Construction de la détail view
    NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    News *news = [newsArray objectAtIndex:[indexPath row]];
    detailViewController.news = news;
    
    // Chargement de la détail view
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}
@end