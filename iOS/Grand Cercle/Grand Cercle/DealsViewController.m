//
//  SecondViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "DealsViewController.h"
#import "AppDelegate.h"


@implementation DealsViewController
@synthesize dealsCell, tview;
@synthesize arrayDeals, imageCache;

NSString *const dealsImageFolder = @"images/deals";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (managedObjectContext == nil) { 
            managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        }
        
        // Mise en place du titre dans les onglets du bas
        self.title = NSLocalizedString(@"Deals", @"");
        
        // Mise en place de l'image dans les onglets du bas
        self.tabBarItem.image = [UIImage imageNamed:@"deals"];

    
        // Récupération des bons plans
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Deal" inManagedObjectContext:managedObjectContext];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        
        NSError *error = nil;
        
        NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil && error == nil) {
            [self setArrayDeals:array];
            [arrayDeals retain];
        }
        else {
            NSLog(@"error %@", error);
            // Deal with error.
        }

    // Configuration du cache des images
	self.imageCache = [[[TKImageCache alloc] initWithCacheDirectoryName:dealsImageFolder] autorelease];
	self.imageCache.notificationName = @"newDealsImage";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newDealsImage" object:nil];
    
    // Mise en place du bouton retour, pour la détail view
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
    }
    return self;
}

/*****************************
 * Mise à jour du table view *
 ****************************/
- (void) newImageRetrieved:(NSNotification*)sender{
    
    // Définition des structures nécéssaires
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    NSArray *paths = [self.tview indexPathsForVisibleRows];
    
    // Pour chaque row de la table view
    for(NSIndexPath *path in paths) {
        
        // On recherche l'image dans le cache
    	NSInteger index = path.row;
        UITableViewCell *cell = [self.tview cellForRowAtIndexPath:path];
        UIImageView *imageView;
        imageView = (UIImageView *)[cell viewWithTag:1];
        
        // Si il n'y avais pas déjà une image on l'affiche
    	if(imageView.image == nil && tag == index){
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}

/************************
 * Chargement de la vue *
 ***********************/
- (void)viewDidLoad {
    [super viewDidLoad];
}

/************************
 * Apparition de la vue *
 ***********************/
-(void)viewDidAppear:(BOOL)animated {
    
    // Récupération des préférences utilisateurs
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    // Coloration de la barre du haut suivant les préférences
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
    
    // Si le thème choisie est Grand Cercle, on laisse l'interligne par défaut, sinon on met l'interligne de la couleur du thème
    UIColor* color;
    if ([[c objectAtIndex:0] floatValue] == 0.0 && [[c objectAtIndex:1] floatValue] == 0.0 && [[c objectAtIndex:2] floatValue] == 0.0) {
        color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.18];
    } else {
        color = [[UIColor alloc] initWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:0.5];
    }
    [self.tview setSeparatorColor:color];
    [color release];
}

/**************************
 * Déchargement de la vue *
 *************************/
- (void)viewDidUnload {
    // Libération des structures qui ne sont plus utilisées
    [dealsCell release];
    dealsCell = nil;
    [arrayDeals release];
    arrayDeals = nil;
    [self setDealsCell:nil];
    [tview release];
    tview = nil;
    [imageCache release];
    self.imageCache = nil;
    [self setTview:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

/************************************
 * Retourne la hauteur des sections *
 ***********************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
    return [arrayDeals count];
}

/*************************************
 * Construction des différentes rows *
 ************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DealCell";
    // Utile pour le chargement des cellules qui ne sont pas dans le champs de vision
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DealCell" owner:self options:nil];
        cell = dealsCell;
        self.dealsCell = nil;
    }
    
    // Récupération du bon plan à mettre dans la cellule
    Deal *deal = (Deal *)[arrayDeals objectAtIndex:[indexPath row]];
    
    // Affichage de l'image de la news
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    
    if (![deal.image isEqualToString:@""]) {
        // test si c'est dans le cache
        NSString *imageKey = [NSString stringWithFormat:@"%x", [deal.image hash]];
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:dealsImageFolder] stringByAppendingPathComponent:imageKey];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
        
        if (!fileExists) {
            // download img async
            UIImage *img = [imageCache imageForKey:imageKey url:[NSURL URLWithString:deal.image] queueIfNeeded:YES tag: indexPath.row];
            [imageView setImage:img];
        }
        else {
            [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    }
    else  [imageView setImage:nil];


    
    // Affichage des labels
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    [label setText: [deal title]];
    
    label = (UILabel *)[cell viewWithTag:3];
    [label setText: [deal subtitle]];
    
    return cell;
}

#pragma mark - Table view delegate

/************************************************
 * Action déclenchée par la sélection d'une row *
 ***********************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Construction de la vue détaillée
    DealsDetailViewController *detailViewController = [[DealsDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    Deal *deal = [arrayDeals objectAtIndex:[indexPath row]];
    detailViewController.deal = deal;
    // Chargement de la vue détaillée
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release]; 
}

/****************************************************************
 * Maintient de la vue verticale en cas de rotation du téléphone*
 ***************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/***************
 * Destructeur *
 **************/
- (void)dealloc {
    [dealsCell release];
    [dealsCell release];
    [tview release];
    [tview release];
    [super dealloc];
}
@end
