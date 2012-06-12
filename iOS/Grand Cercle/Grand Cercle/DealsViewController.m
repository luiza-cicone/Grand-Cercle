//
//  SecondViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "DealsViewController.h"

@implementation DealsViewController
@synthesize bonsPlansCell, arrayBonsPlans, urlArray, imageCache, tview;

/****************************
 * Initialisation de la vue *
 ***************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Mise en place du titre dans les onglets du bas
        self.title = NSLocalizedString(@"Deals", @"");
        // Mise en place de l'image dans les onglets du bas
        self.tabBarItem.image = [UIImage imageNamed:@"deals"];
    }
    
    // Récupération des bons plans
    self.arrayBonsPlans = [[DealsParser instance] arrayDeals];

    // Récupération des url des images des bons plans
    self.urlArray = [[NSMutableArray alloc] initWithCapacity:[self.arrayBonsPlans count]];
    for (int i = 0; i < [self.arrayBonsPlans count]; i++) {
        Deals *bp = [self.arrayBonsPlans objectAtIndex:i];
        [self.urlArray addObject:[bp logo]];
    }
	
    // Configuration du cache
	self.imageCache = [[[TKImageCache alloc] initWithCacheDirectoryName:@"logos"] autorelease];
	self.imageCache.notificationName = @"newLogoCache";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newLogoCache" object:nil];
    
    // Mise en place du bouton retour, pour la détail view
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];

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
    [bonsPlansCell release];
    bonsPlansCell = nil;
    [urlArray release];
    urlArray = nil;
    [arrayBonsPlans release];
    arrayBonsPlans = nil;
    [self setBonsPlansCell:nil];
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
    return [arrayBonsPlans count];
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
        cell = bonsPlansCell;
        self.bonsPlansCell = nil;
    }
    
    // Récupération du bon plan à mettre dans la cellule
    Deals *b = (Deals *)[arrayBonsPlans objectAtIndex:[indexPath row]];
    
    // Récupération et affichage de l'image du bon plan
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    UIImage *img = [imageCache imageForKey:[NSString stringWithFormat:@"%d", [indexPath row]] url:[NSURL URLWithString:[urlArray objectAtIndex: indexPath.row]] queueIfNeeded:YES tag: indexPath.row]; 
    [imageView setImage:img];
    
    // Affichage des labels
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:2];
    [label setText: [b title]];
    label = (UILabel *)[cell viewWithTag:3];
    [label setText: [b summary]];
    
    return cell;
}

#pragma mark - Table view delegate

/************************************************
 * Action déclenchée par la sélection d'une row *
 ***********************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Construction de la vue détaillée
    DealsDetailViewController *detailViewController = [[DealsDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    Deals *b = [arrayBonsPlans objectAtIndex:[indexPath row]];
    detailViewController.bonPlan = b;
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
    [bonsPlansCell release];
    [bonsPlansCell release];
    [tview release];
    [tview release];
    [super dealloc];
}
@end
