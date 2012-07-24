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
#import "AppDelegate.h"

@implementation NewsViewController
@synthesize newsCell;
@synthesize tView;
@synthesize newsArray, urlArray;

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
        

        NSManagedObjectContext *moc = self->managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"News" inManagedObjectContext:moc];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        
        NSError *error = nil;
        
        NSArray *array = [moc executeFetchRequest:request error:&error];
        if (array != nil && error == nil) {
            NSLog(@"array count %d", [array count]);
        }
        else {
            NSLog(@"error %@", error);
            // Deal with error.
        }
        [self setNewsArray:array];
        [newsArray retain];
        
        
        // Récupération des news
//        self.newsArray = [[NewsParser instance] arrayNews];
//    
//        // Récupération des liens des images des news
//        self.urlArray = [[NSMutableArray alloc] initWithCapacity:[self.newsArray count]];
//        for (int i = 0; i < [self.newsArray count]; i++) {
//            Newss *n = [self.newsArray objectAtIndex:i];
//            [self.urlArray addObject:[n logo]];
//        }
//	
//        // Configuration du cache
//        imageCache = [[TKImageCache alloc] initWithCacheDirectoryName:@"images"];
//        imageCache.notificationName = @"newImageCache";
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newImageCache" object:nil];
    
        // Mise en place du bouton retour pour la détail view
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [backButton release];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    // Libération des structures
    [self setNewsCell:nil];
    [newsCell release];
    [urlArray release];
    [newsArray release];
    urlArray = nil;
    newsArray = nil;
    newsCell = nil;
	[imageCache release];
    imageCache = nil;
    [tView release];
    [super viewDidUnload];
}

/************************
 * Apparition de la vue *
 ***********************/
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

/****************************************************************
 * Maintient de la vue verticale en cas de rotation du téléphone*
 ***************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


/*****************************
 * Mise à jour du table view *
 ****************************/
- (void) newImageRetrieved:(NSNotification*)sender {
    
    // Définition des structures
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    NSArray *paths = [self.tView indexPathsForVisibleRows];
    
    // Pour chaque row de la table view
    for(NSIndexPath *path in paths) {
        
        // On charche l'image dans le cache
    	NSInteger index = path.row;
        UITableViewCell *cell = [self.tView cellForRowAtIndexPath:path];
        UIImageView *imageView;
        imageView = (UIImageView *)[cell viewWithTag:1];
        
        // Si il n'y a pas d'image on l'affiche
    	if(imageView.image == nil && tag == index){
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}

#pragma mark - Table view data source

/************************************
 * Retourne la hauteur des sections *
 ***********************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

/**********************************
 * Retourne le nombre de sections *
 *********************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/*******************************************
 * Retourne le nombre de rows par sections *
 ******************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsArray count];
}

/*************************************
 * Construction des différentes rows *
 ************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = newsCell;
        self.newsCell = nil;
    }
    
    // Définition de la news
    News *n = (News *)[newsArray objectAtIndex:[indexPath row]];
    
    // Affichage de l'image de la news
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    UIImage *img = [imageCache imageForKey:[NSString stringWithFormat:@"%d", indexPath.row] url:[NSURL URLWithString:[urlArray objectAtIndex: indexPath.row]] queueIfNeeded:YES tag: indexPath.row];
    [imageView setImage:img];
    
    // Affichage des labels
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:2];
    [label setText: [n title]];
    label = (UILabel *)[cell viewWithTag:3];
    [label setText:[n pubDate]];
    
    return cell;
}

#pragma mark - Table view delegate

/************************************************
 * Action déclenchée par la sélection d'une row *
 ***********************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Construction de la détail view
    NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    Newss *n = [newsArray objectAtIndex:[indexPath row]];
    detailViewController.news = n;
    
    // Chargement de la détail view
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

/***************
 * Destructeur *
 **************/
- (void)dealloc {
    [newsCell release];
    [urlArray release];
    [newsArray release];
	[imageCache release];
    [super dealloc];
}
@end