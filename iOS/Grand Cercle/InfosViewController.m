//
//  InfosViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 7/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "InfosViewController.h"

// Définition des sections de la table view
#define GC 0
#define EXTERN 1
#define INFOS 2

// Définition des rows de la section EXTERN
#define MAIL 0
#define SITE 1
#define FB 2

@implementation InfosViewController

@synthesize topCell, descriptionCell;

/****************************
 * Initialisation de la vue *
 ***************************/
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Titre apparaissant dans les onglets du bas
        self.title = NSLocalizedString(@"Infos", @"Infos");
        // Image apparaissant dans l'onglet en bas
        self.tabBarItem.image = [UIImage imageNamed:@"infos"];
    }
    return self;
}

/************************
 * Chargement de la vue *
 ***********************/
- (void)viewDidLoad {
    [super viewDidLoad];
}

/****************************************************************
 * Maintient de la vue verticale en cas de rotation du téléphone*
 ***************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**************************
 * Déchargement de la vue *
 *************************/
- (void)viewDidUnload {
    [super viewDidUnload];
}

/************************************************
 * Action réalisée après l'apparition de la vue *
 ***********************************************/
- (void) viewDidAppear:(BOOL)animated {
    
    // Récupération de la couleur des préférences utilisateurs
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    // Coloration de la barre du haut suivant les préférences
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
    
    // Coloration de l'interligne suivant les préférences, si Noir Grand Cercle on laisse la couleur par défaut
    if ([[c objectAtIndex:0] floatValue] == 0.0 && [[c objectAtIndex:1] floatValue] == 0.0 && [[c objectAtIndex:2] floatValue] == 0.0) {
        UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.18];
        [self.tableView setSeparatorColor: color];
        [color release];
    }
    else {
        UIColor *color = [[UIColor alloc] initWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:0.5];
        [self.tableView setSeparatorColor:color];
        [color release];
    }
}

#pragma mark - Table view data source

/**********************************
 * Retourne le nombre de sections *
 *********************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

/*******************************************
 * Retourne le nombre de rows par sections *
 ******************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == GC)
        return 1;
    else if (section == EXTERN)
        return 3;
    else if (section == INFOS)
        return 1;
    else
        return 0;
}

/**********************************
 * Titre les différentes sections *
 *********************************/
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == EXTERN) {
        return @"Contact";
    }
    else if (section == INFOS) {
        return @"Détails";
    }
    else {
        return @"";
    }
}

/************************************
 * Retourne la hauteur des sections *
 ***********************************/
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case GC :
            return 60;
            break;
            
        case EXTERN :
            return 40;
            break;
            
        case INFOS :
            return 650;
            break;
            
        default :
            return 0;
            break;
    }
}

/*************************************
 * Construction des différentes rows *
 ************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    UITableViewCell *cell = nil;
    
    // Si on se trouve dans la section GC, on met en place la cellule de titre
    if (indexPath.section == GC) {
        CellIdentifier = @"InfosTopCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"InfosTopCell" owner:self options:nil];
            cell = topCell;
            self.topCell = nil;
        }
    
    // Si on se trouve dans la section EXTERN, on met en place les cellules contenant les liens externes
    } else if (indexPath.section == EXTERN) {
        
        CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if (indexPath.row == SITE)
            [cell.textLabel setText:@"Site Web"];
        else if (indexPath.row == FB)
            [cell.textLabel setText:@"Page Facebook"];
        else if (indexPath.row == MAIL)
            [cell.textLabel setText:@"E-mail"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    // Si on se trouve dans la section INFOS, on met en place la cellule de description du Grand Cercle
    } else if (indexPath.section == INFOS) {
        
        CellIdentifier = @"DescriptionCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"InfosDescriptionCell" owner:self options:nil];
            cell = descriptionCell;
            self.descriptionCell = nil;
        }
        
        UIWebView *tv = (UIWebView *)[cell viewWithTag:1];
        [tv sizeToFit];
        [tv loadHTMLString:@"<p>Le Grand Cercle, c'est l'un des plus grands BDE de France, à votre service, pour vous offrir des moments inoubliables !</p>\
         <p>Le GC, c'est une cinquantaine d'étudiants de toutes les écoles de Grenoble INP qui s'occupent d'organiser les plus gros événements de votre année : la soirée d'intégration, la soirée d'Automne, le Gala, et tant d'autres !</p>\
         <p>Mais son rôle, c'est aussi d'assurer le lien entre les différentes écoles et BDE, les élus et les étudiants de Grenoble INP. N'hésitez pas à nous contacter pour toute information !</p>\
         <p>Le GC, c'est aussi une représentation nationale grâce au Bureau National des Élèves Ingénieurs (BNEI), en tant qu'administrateur, nous pouvons faire remonter vos idées ou questions !</p>\
         <p>Enfin, et surtout, le GC, ce sont des gens toujours prêts à vous aider, en toutes circonstances : pour demander un renseignement, pour un coup de pouce sur un projet, ou tout simplement pour faire la fête ;)</p>" baseURL:nil];
    }
    return cell;
}

#pragma mark - Table view delegate

/************************************************
 * Action déclenchée par la sélection d'une row *
 ***********************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Pour la section EXTERN, dans chaque cas on ouvre une nouvelle page avec le lien
    if (indexPath.section == EXTERN) {
        if (indexPath.row == SITE)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://grandcercle.org"]];
        else if (indexPath.row == FB)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/grandcercle"]];
        else if (indexPath.row == MAIL)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:grandcercle@grandcercle.org"]];            
    }
}

@end
