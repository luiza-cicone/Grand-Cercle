//
//  PreferencesViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "SettingsViewController.h"

// Définition des sections de la table view
#define FILTER_EVENT 0
#define FILTER_NEWS 2
#define PERSO 1

@implementation SettingsViewController

/****************************
 * Initialisation de la vue *
 ***************************/
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Titre apparaissant en haut
        self.title = NSLocalizedString(@"Settings", @"Settings");
        // Image apparaissant dans l'onglet en bas
        self.tabBarItem.image = [UIImage imageNamed:@"settings"];
    }
    return self;
}

/************************
 * Chargement de la vue *
 ***********************/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Mise en place du bouton retour
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release]; 
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
- (void)viewDidAppear:(BOOL)animated {
    
    // Récupération de la couleur des préférences utilisateurs
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
    NSArray *c = [defaults objectForKey:@"theme"];
    
    // Coloration de la barre du haut suivant les préférences
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
    
    // Coloration de l'interligne suivant les préférences, si Noir Grand Cercle on laisse la couleur par défaut
    if ([[c objectAtIndex:0] floatValue] == 0.0 && [[c objectAtIndex:1] floatValue] == 0.0 && [[c objectAtIndex:2] floatValue] == 0.0)
       [self.tableView setSeparatorColor: [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.18]];
    else
        [self.tableView setSeparatorColor:[[UIColor alloc] initWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:0.5]];
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
    if (section == FILTER_EVENT)
        return 3;
    else if (section == FILTER_NEWS)
        return 2;
    else
        return 1;
}

/**********************************
 * Titre les différentes sections *
 *********************************/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == FILTER_EVENT)
        return @"Filtrer les événements par";
    else if (section == FILTER_NEWS)
        return @"Filtrer les news par";
    else if (section == PERSO)
        return @"Personnaliser l'interface";
    else return @"";
}

/*************************************
 * Construction des différentes rows *
 ************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Si on se trouve dans la section FILTER_EVENT, on met en place les trois rows de filtre pour les événements
    if (indexPath.section == FILTER_EVENT) { 
    
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Cercles"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Clubs & Associations"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"Type"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }

    // Si on se trouve dans la section FILTER_NEWS, on met en place les deux rows de filtre pour les news
    } else if (indexPath.section == FILTER_NEWS) {
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Cercles"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Clubs & Associations"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    
    // Si on se trouve dans la section PERSO, on met en place la row de thème
    } else if (indexPath.section == PERSO) {
        [cell.textLabel setText:@"Thème"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }    
    return cell;
}

#pragma mark - Table view delegate

/************************************************
 * Action déclenchée par la sélection d'une row *
 ***********************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Initialisation et lancement de la vue détaillée
    SettingsDetailViewController *detailViewController = [[SettingsDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.filter = indexPath;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end