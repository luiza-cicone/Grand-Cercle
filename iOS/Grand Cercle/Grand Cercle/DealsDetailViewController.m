//
//  DealsDetailViewController.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "DealsDetailViewController.h"

@implementation DealsDetailViewController
@synthesize bonPlan, cellBonPlanTop, cellBonPlanDescription;

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
    self.title = NSLocalizedString(@"Deals", @"Deals");
    webViewHeight = 0;
    
    // Définition de la web view pour la description
    [[NSBundle mainBundle] loadNibNamed:@"DealsDescriptionCell" owner:self options:nil];
    UIWebView *webView;
    webView = (UIWebView *)[cellBonPlanDescription viewWithTag:1];
    // On implémentera les fonctions delegate ici
    webView.delegate = self;
    [webView loadHTMLString:bonPlan.description baseURL:nil];
}

/************************
 * Apparition de la vue *
 ***********************/
- (void)viewDidAppear:(BOOL)animated {
    
    // Récupération des préférences utilisateurs 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    // Coloration de la barre du haut suivant les préférences
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
}

/*************************
 * Disparition de la vue *
 ************************/
- (void)viewDidUnload {
    // Libération des structures
    [cellBonPlanDescription release];
    cellBonPlanDescription = nil;
    [cellBonPlanTop release];
    cellBonPlanTop = nil;
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
    UITableViewCell *cell = nil;;
    switch (indexPath.section) {
            
        // Si on se trouve dans la première section
        case 0:
            // On met en place la cellule titre
            CellIdentifier = @"DealsTopCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"DealsTopCell" owner:self options:nil];
                cell = cellBonPlanTop;
                self.cellBonPlanTop = nil;
            }
            
            // On charge l'image du bon plan
            UIImageView *imageView;
            imageView = (UIImageView *)[cell viewWithTag:1];
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:(NSString*)[bonPlan logo]]];
            UIImage *myimage2 = [[UIImage alloc] initWithData:data];
            [data release];
            [imageView setImage:myimage2];
            [myimage2 release];
            
            // On charge les labels
            UILabel *label;
            label = (UILabel *)[cell viewWithTag:2];
            [label setText: [bonPlan title]];
            label = (UILabel *)[cell viewWithTag:3];
            [label setText: [bonPlan summary]];
            break;
            
        // Si on se trouve dans la deuxième section
        case 1:

            // On met en place la cellule description
            CellIdentifier = @"DescriptionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                [[NSBundle mainBundle] loadNibNamed:@"DealsDescriptionCell" owner:self options:nil];
                cell = cellBonPlanDescription;
                self.cellBonPlanDescription = nil;
            }
            
            // On met en place un webView avec la description du bon plan
            UIWebView *webView;
            webView = (UIWebView *)[cell viewWithTag:1];
            webView.delegate = self;
            [webView loadHTMLString:bonPlan.description baseURL:nil];
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
    
    // Calcul de la taille de la webView
    [[NSBundle mainBundle] loadNibNamed:@"DealsDescriptionCell" owner:self options:nil];
    NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, [output intValue])];
    
    // On met en place la bonne taille pour la webView
    if (webViewHeight == 0) {
        webViewHeight = [output intValue];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*************************
 * Disparition de la vue *
 ************************/
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
        case 0 :
            return 80;
            break;
            
        case 1 :
            return webViewHeight + 10;
            break;
            
        default :
            return 0;
            break;
    }
}

@end
