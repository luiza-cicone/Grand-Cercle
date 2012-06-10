//
//  SettingsDetailViewController.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 4/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsDetailViewController : UITableViewController {
    // Tableaux contenant la liste des string à afficher pour le choix des préférences
    NSArray *clubsArray, *cerclesArray, *typesArray, *themesArray;
    // Tableaux contenant les choix des utilisateurs concernant leurs préférences pour les filtres
    NSMutableArray *clubsChoice, *cerclesChoice, *typesChoice;
    // Thème choisi par les utilisateurs
    UIColor *themeChoice;
    // Chemin représentant le menu dans lequel on se trouve
    NSIndexPath *filter;
}

@property (nonatomic, retain) NSArray *clubsArray, *cerclesArray, *typesArray, *themesArray;
@property (nonatomic, retain) NSMutableArray *clubsChoice, *cerclesChoice, *typesChoice;
@property (nonatomic, retain) NSIndexPath *filter;
@property (nonatomic, retain) UIColor *themeChoice;

@end
