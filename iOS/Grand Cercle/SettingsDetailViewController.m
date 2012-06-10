//
//  SettingsDetailViewController.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "SettingsDetailViewController.h"
#import "FilterParser.h"
#import "EventsParser.h"

// Définition des sections de la table view
#define EVENTS 0
#define NEWS 2
#define PERSO 1

// Définition des rows pour les sections Event et News
#define FILTER_CERCLES 0
#define FILTER_CLUBS 1
// Seulement pour Event
#define FILTER_TYPE 2
// Définition de la row pour la section Perso
#define PERSO_COLOR 0

@implementation SettingsDetailViewController
@synthesize cerclesArray, clubsArray, typesArray, themesArray, clubsChoice, cerclesChoice, typesChoice, themeChoice, filter;

// Dictionnaire contenant les différents thèmes et leur couleur associée
NSMutableDictionary *themesDico;
// Booléen pour savoir si une préférence a été modifiée ou non
BOOL changed = 0;

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
    
    // On se trouve dans le filtrage par cercles, pour les news ou les événements
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
        
        // Récupération du tableau contenant les noms des cercles
        cerclesArray = [[FilterParser instance] arrayCercles];
        // Récupération des préférences utilisateurs
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *cerclesDico = [defaults objectForKey:@"filtreCercles"];
        // Initialisation du dictionnaire des choix pour les cercles
        cerclesChoice = [[NSMutableArray alloc] initWithCapacity:[cerclesArray count]];
        for (NSString *cercle in cerclesArray)
            [cerclesChoice addObject:[cerclesDico objectForKey:cercle]];
    
    // On se trouve dans le filtrage par clubs et associations, pour les news ou les événements
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {
        // Récupération du tableau contenant les noms des clubs et associations
        clubsArray = [[FilterParser instance] arrayClubs];
        // Récupération des préférences utilisateurs
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *clubsDico  = [defaults objectForKey:@"filtreClubs"];
        // Initialisation du dictionnaire des choix pour les clubs et associations
        clubsChoice = [[NSMutableArray alloc] initWithCapacity:[clubsArray count]];
        for (NSString *club in clubsArray)
            [clubsChoice addObject:[clubsDico objectForKey:club]];
        
    // On se trouve dans le filtrage par type, pour les événements
    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        // Récupération du tableau contenant les noms des types
        typesArray = [[FilterParser instance] arrayTypes];
        // Récupération des préférences utilisateurs
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSMutableDictionary *typesDico = [defaults objectForKey:@"filtreTypes"];
        // Initialisation du dictionnaire des choix pour les types
        typesChoice = [[NSMutableArray alloc] initWithCapacity:[typesArray count]];
        for (NSString *type in typesArray)
            [typesChoice addObject:[typesDico objectForKey:type]];
    
    // On se trouve dans le filtrage par type, pour les événements
    } else if (filter.section == PERSO && filter.row == PERSO_COLOR) {
        
        // Récupération des préférences utilisateurs
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSArray *c = [defaults objectForKey:@"theme"];
        // Initialisation du dictionnaire des thèmes
        themeChoice = [[UIColor alloc] initWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1];
        UIColor *blackColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
        UIColor *redColor = [[UIColor alloc] initWithRed:.75 green:.08 blue:.12 alpha:1];
        UIColor *greenColor = [[UIColor alloc] initWithRed:.59 green:.74 blue:.06 alpha:1];
        UIColor *blueColor = [[UIColor alloc] initWithRed:0 green:0.59 blue:0.83 alpha:1];
        UIColor *darkBlueColor = [[UIColor alloc] initWithRed:0 green:.29 blue:.61 alpha:1];
        UIColor *yellowColor = [[UIColor alloc] initWithRed:1 green:.80 blue:0 alpha:1];
        UIColor *orangeColor = [[UIColor alloc] initWithRed:.94 green:.59 blue:0 alpha:1];
        UIColor *purpleColor = [[UIColor alloc] initWithRed:.59 green:.08 blue:0.49 alpha:1];
        themesDico = [[NSMutableDictionary alloc] initWithCapacity:8];
        [themesDico setObject:blackColor forKey:@"Noir Grand Cercle"];
        [themesDico setObject:darkBlueColor forKey:@"Bleu Ense3"];
        [themesDico setObject:greenColor forKey:@"Vert Ensimag"];
        [themesDico setObject:blueColor forKey:@"Bleu GI"];
        [themesDico setObject:redColor forKey:@"Rouge Phelma"];
        [themesDico setObject:orangeColor forKey:@"Orange Pagora"];
        [themesDico setObject:purpleColor forKey:@"Violet Esisar"];
        [themesDico setObject:yellowColor forKey:@"Jaune CPP"];
        themesArray = [[NSArray alloc] initWithObjects:@"Noir Grand Cercle", @"Bleu Ense3", @"Vert Ensimag", @"Bleu GI", @"Rouge Phelma", @"Orange Pagora", @"Violet Esisar", @"Jaune CPP", nil];
    }

    // Titre apparaissant en haut
    self.title = NSLocalizedString(@"Settings", @"Settings");
    self.clearsSelectionOnViewWillAppear = NO;
}

/**************************
 * Déchargement de la vue *
 *************************/
- (void)viewDidUnload {
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
    if (filter.section == EVENTS || filter.section == NEWS || filter.section == PERSO)
        return 1;
    else
        return 0;
}

/*******************************************
 * Retourne le nombre de rows par sections *
 ******************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES)
        return [cerclesArray count];
    else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS)
        return [clubsArray count];
    else if (filter.section == EVENTS && filter.row == FILTER_TYPE)
        return [typesArray count];
    else if (filter.section == PERSO && filter.row == PERSO_COLOR)
        return [themesArray count];
    return 0;
}

/**********************************
 * Titre les différentes sections *
 *********************************/
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES)
        return @"Cercles";
    else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS)
            return @"Clubs & Associations";
    else if (filter.section == EVENTS && filter.row == FILTER_TYPE)
        return @"Types d'événements";
    else if (filter.section == PERSO && filter.row == PERSO_COLOR)
        return @"Thèmes";
    return @"";
}

/*************************************
 * Construction des différentes rows *
 ************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Définition du booléen, pour savoir si un élément est check ou non
    BOOL checked;
    
    // On récupére dans les dictionnaires correspondant les différents booléens check
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
            [cell.textLabel setText:(NSString *)[cerclesArray objectAtIndex:indexPath.row]];
             checked = [[cerclesChoice objectAtIndex:indexPath.row] boolValue];
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {
            [cell.textLabel setText:[clubsArray objectAtIndex:indexPath.row]];
            checked = [[clubsChoice objectAtIndex:indexPath.row] boolValue];
    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        [cell.textLabel setText:(NSString *)[typesArray objectAtIndex:indexPath.row]];
        checked = [[typesChoice objectAtIndex:indexPath.row] boolValue];
    } else if (filter.section == PERSO && filter.row == PERSO_COLOR) {
        [cell.textLabel setText:(NSString *)[themesArray objectAtIndex:indexPath.row]];
        checked = ([themeChoice isEqual:[themesDico objectForKey:(NSString *)[themesArray objectAtIndex:indexPath.row]]]);
        // On met directement la couleur de la barre du haut à jour pour que l'utilisateur puisse voir le rendu du thème choisi
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        NSArray *c = [defaults objectForKey:@"theme"];
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:[[c objectAtIndex:0] floatValue] green:[[c objectAtIndex:1] floatValue] blue:[[c objectAtIndex:2] floatValue] alpha:1]];
    }
    
    // Si checked est à true, on met le check graphique
    cell.accessoryType = (checked) ? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

/************************************************
 * Action déclenchée par la sélection d'une row *
 ***********************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dans chaque cas, si l'utilisateur clique on enlève le check ou on le met
    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
        BOOL value = [[cerclesChoice objectAtIndex:indexPath.row] boolValue];
        value = 1 - value;
        [cerclesChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {
        BOOL value = [[clubsChoice objectAtIndex:indexPath.row] boolValue];
        value = 1 - value;
        [clubsChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        BOOL value = [[typesChoice objectAtIndex:indexPath.row] boolValue];
        value = 1 - value;
        [typesChoice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:value]];
    } else if (filter.section == PERSO && filter.row == PERSO_COLOR) {
        // Dans ce cas, on sauvegarde directement la couleur choisie dans les préférences
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
        themeChoice = [themesDico objectForKey:(NSString *)[themesArray objectAtIndex:indexPath.row]];
        CGFloat* colors = (CGFloat *)CGColorGetComponents(themeChoice.CGColor);
        NSArray *c = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:colors[0]], [NSNumber numberWithFloat:colors[1]], [NSNumber numberWithFloat:colors[2]], nil];
        [defaults setObject:c forKey:@"theme"];
        [c release];
    }
    
    // L'utilisateur a changé une de ses préférences, on recharge la table view
    changed = 1;
    [tableView reloadData];
}

/**************************************************
 * Action déclenchée par la disparition de la vue *
 *************************************************/
- (void)viewDidDisappear:(BOOL)animated {
    
    // On met à jour dans les préférences utilisateurs les nouveaux choix effectués
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  

    if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CERCLES) {
        NSMutableDictionary *cerclesDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreCercles"]];
        for (int i = 0; i < [cerclesArray count]; i++) {
            [cerclesDico setObject:[cerclesChoice objectAtIndex:i] forKey:[cerclesArray objectAtIndex:i]];
        }        
        [defaults setObject:cerclesDico forKey:@"filtreCercles"];
        
    } else if ((filter.section == EVENTS || filter.section == NEWS) && filter.row == FILTER_CLUBS) {

        NSMutableDictionary *clubsDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreClubs"]];
        for (int i = 0; i < [clubsArray count]; i++) {
            [clubsDico setObject:[clubsChoice objectAtIndex:i] forKey:[clubsArray objectAtIndex:i]];
        }
        [defaults setObject:clubsDico forKey:@"filtreClubs"];

    } else if (filter.section == EVENTS && filter.row == FILTER_TYPE) {
        NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:@"filtreTypes"]];
        for (int i = 0; i < [typesArray count]; i++) {
            [typesDico setObject:[typesChoice objectAtIndex:i] forKey:[typesArray objectAtIndex:i]];
        }
        [defaults setObject:typesDico forKey:@"filtreTypes"];
    }
    
    // Si quelquechose a été changé, on reparse les événements
    if (changed == 1) {
        [[EventsParser instance] loadEventsFromFile];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"changedEvents"];
    }
    changed = 0;

    // Validation des nouvelles préférences
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self viewDidUnload];
}

@end