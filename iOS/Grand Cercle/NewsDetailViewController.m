//
//  NewsDetailViewController.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 01/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NSString+HTML.h"
#import "Association.h"

// Section
#define TITRE 0
#define DESCRIPTION 1

@implementation NewsDetailViewController
@synthesize news, cellNewsDescription, cellNewsTop;

/****************************
 * Initialisation de la vue *
 ***************************/
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    return self;
}

/************************
 * Chargement de la vue *
 ***********************/
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"News", @"News");
    webViewHeight = 0;

    // Définition du webview qui sera delegate ici
    [[NSBundle mainBundle] loadNibNamed:@"NewsDescriptionCell" owner:self options:nil];
    UIWebView *webView;
    webView = (UIWebView *)[cellNewsDescription viewWithTag:1];
    webView.delegate = self;
    [webView loadHTMLString:news.description baseURL:nil];
}

/************************
 * Apparition de la vue *
 ***********************/
- (void)viewDidAppear:(BOOL)animated {
    // Récupération des préférences utilisateurs
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    // Coloration de la barre supérieure avec la
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}

/**************************
 * Déchargement de la vue *
 *************************/
- (void)viewDidUnload {
    // Destruction des structures
    [cellNewsDescription release];
    cellNewsDescription = nil;
    [cellNewsTop release];
    cellNewsTop = nil;
    [super viewDidUnload];
}

/****************************************************************
 * Maintient de la vue verticale en cas de rotation du téléphone*
 ***************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

/**********************************
 * Retourne le nombre de sections *
 *********************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/*******************************************
 * Retourne le nombre de rows par sections *
 ******************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/*************************************
 * Construction des différentes rows *
 ************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        
        // Première section
        case TITRE:
            
            // Mise en place de la cellule de titre
            CellIdentifier = @"NewsTopCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"NewsTopCell" owner:self options:nil];
                cell = cellNewsTop;
                self.cellNewsTop = nil;
            }
            
            // Chargement de l'image de la news
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];

            if (![news.image isEqualToString:@""]) {
                // test si c'est dans le cache
                NSString *imageKey = [NSString stringWithFormat:@"%x", [news.image hash]];
                
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:@"images/news"] stringByAppendingPathComponent:imageKey];
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
                
                if (fileExists) {
                    [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
                } else {
                    [imageView setImage:nil];
                }
            } else {
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
            
            // Chargement des labels
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:2];
            [label setText: [news title]];
            label = (UILabel *)[cell viewWithTag:3];
            [label setText:[news pubDate]];
            break;
            
        // Deuxième section
        case DESCRIPTION:
            
            // Mise en place de la cellule description de la news
            CellIdentifier = @"DescriptionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"NewsDescriptionCell" owner:self options:nil];
                cell = cellNewsDescription;
                self.cellNewsDescription = nil;
            }
            
            // Initialisation du webView
            UIWebView *webView;
            webView = (UIWebView *)[cell viewWithTag:1];
            webView.delegate = self;
            [webView loadHTMLString:[news content] baseURL:nil];
            [webView sizeToFit];
            
            break;
            
        default:
            break;
    }
    return cell;
}

/***********************************
 * Fin du chargement de la webView *
 **********************************/
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // Calcul de la taille pour la webView
    [[NSBundle mainBundle] loadNibNamed:@"NewsDescriptionCell" owner:self options:nil];
    NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, [output intValue])];
    
    // On met en place la bonne taille pour la webView
    if (webViewHeight == 0) {
        webViewHeight = [output intValue];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/********************************
 * Disparition future de la vue *
 *******************************/
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    webViewHeight = 0;
}

/************************************************************************
 * Ouvrir un lien dans une nouvelle fenêtre, celle du navigateur safari *
 ***********************************************************************/
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

/************************************
 * Retourne la hauteur des sections *
 ***********************************/
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case TITRE :
            return 80;
            break;
         
        case DESCRIPTION :
            return webViewHeight + 10;
            break;
            
        default :
            return 0;
            break;
    }
}

/***************
 * Destructeur *
 **************/
- (void)dealloc {
    [cellNewsDescription release];
    [cellNewsTop release];
    [super dealloc];
}
@end
