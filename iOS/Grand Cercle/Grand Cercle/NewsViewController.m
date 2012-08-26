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

@implementation NewsViewController
@synthesize newsCell;
@synthesize tView;
@synthesize newsArray;
@synthesize imageCache;

NSString *const newsImageFolder = @"images/news";

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
        

        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:entityDescription];
        
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
    
        self.imageCache = [[[TKImageCache alloc] initWithCacheDirectoryName:newsImageFolder] autorelease];
        self.imageCache.notificationName = @"newNewsImage";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newImageRetrieved:) name:@"newNewsImage" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newAssosImageRetrieved:) name:@"newAssosImage" object:nil];
        
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
    [newsArray release];
    newsArray = nil;
    newsCell = nil;
	[imageCache release];
    imageCache = nil;
    [tView release];
    [super viewDidUnload];
}

- (void)dealloc {
    [newsCell release];
    [newsArray release];
	[imageCache release];
    [super dealloc];
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
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        
        // Si il n'y a pas d'image on l'affiche
    	if(imageView.image == nil && tag == index){
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
}

- (void) newAssosImageRetrieved:(NSNotification*)sender {
    
    // Définition des structures
	NSDictionary *dict = [sender userInfo];
    NSInteger tag = [[dict objectForKey:@"tag"] intValue];
    
    NSArray *paths = [self.tView indexPathsForVisibleRows];
    // Pour chaque row de la table view
    for(NSIndexPath *path in paths) {
        
        // On charche l'image dans le cache
    	NSInteger index = path.row;
        UITableViewCell *cell = [self.tView cellForRowAtIndexPath:path];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        
        // Si il n'y a pas d'image on l'affiche
    	if(imageView.image == nil && tag == [[[[newsArray objectAtIndex:index] author] idAssos] intValue] ){
            imageView.image = [dict objectForKey:@"image"];
            [cell setNeedsLayout];
        }
    }
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
    
    if (![news.image isEqualToString:@""]) {
        // test si c'est dans le cache
        NSString *imageKey = [NSString stringWithFormat:@"%x", [news.image hash]];
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:newsImageFolder] stringByAppendingPathComponent:imageKey];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
        
        if (!fileExists) {
            // download img async
            UIImage *img = [imageCache imageForKey:imageKey url:[NSURL URLWithString:news.image] queueIfNeeded:YES tag: indexPath.row];
            [imageView setImage:img];
        }
        else {
            [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    }
    else {
        NSString *imageKey = [NSString stringWithFormat:@"%x", [news.author.imagePath hash]];
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:@"images/assos"] stringByAppendingPathComponent:imageKey];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
        
        
        if (!fileExists) {
            [imageView setImage:nil];
        }
        else {
            [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    }
    
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