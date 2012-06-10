//
//  AssociationParser.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "FilterParser.h"

@implementation FilterParser
@synthesize arrayClubs, arrayCercles, arrayTypes;

// Patron singleton, unique instance du parser des noms des cercles, clubs et associations
static FilterParser *instanceAssociation = nil;

/****************************************************************************************************************
 * Patron singleton, méthode retournant l'unique instance du parser des noms des cercles, clubs et associations *
 ***************************************************************************************************************/
+ (FilterParser *) instance {
    if (instanceAssociation == nil) {
        instanceAssociation = [[self alloc] init];
    }
    return instanceAssociation;
}

/***************************************************
 * Méthode récupérant les informations nécessaires *
 **************************************************/
- (void) handleNames:(TBXMLElement *)listNamesToParse toArray:(NSMutableArray *)array {
    
    // Tant qu'il y a un événement à traiter
	do {
        
        // Récupération du nom du cercle, club ou d'association
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:listNamesToParse];
        NSString *nomAssociation = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];
        
        // Ajout du nom au tableau
        [array addObject:nomAssociation];
        
	} while ((listNamesToParse = listNamesToParse->nextSibling));
}

/***************************************************
 * Méthode de parsage des données du site internet *
 **************************************************/
- (void)loadStuffFromURL { 
    
    // Initialisation du tableau contenant les noms
    arrayCercles = [[NSMutableArray alloc] initWithCapacity:3];
    arrayClubs = [[NSMutableArray alloc] initWithCapacity:3];
    arrayTypes = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Si le premier lien du fichier xml est correct, ce block est appelé
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handleNames:tbxmlDocument.rootXMLElement->firstChild toArray:arrayCercles];
    };
    
    // Si le deuxième lien du fichier xml est correct, ce block est appelé
    TBXMLSuccessBlock successBlock2 = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handleNames:tbxmlDocument.rootXMLElement->firstChild toArray:arrayClubs];
    };
    
    // Si le troisième lien du fichier xml est correct, ce block est appelé
    TBXMLSuccessBlock successBlock3 = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleNames:tbxmlDocument.rootXMLElement->firstChild toArray:arrayTypes];
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Si un des liens des fichiers xml est incorrect, ce block est appelé
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/cercles/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/clubs/data.xml"] 
                               success:successBlock2 
                               failure:failureBlock];
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/types/data.xml"] 
                                   success:successBlock3 
                                   failure:failureBlock];
}

/***********************************************************
 * Méthode de parsage des données de la sauvegarde interne *
 **********************************************************/
-(void) loadStuffFromFile {
    
    // Initialisation du tableau contenant les noms
    arrayCercles = [[NSMutableArray alloc] initWithCapacity:3];
    arrayClubs = [[NSMutableArray alloc] initWithCapacity:3];
    arrayTypes = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Récupération du chemin de la sauvegarde interne
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Initialisation des fichiers TBXML avec le chemin de la sauvegarde interne
    NSError *error = nil;
    NSData * data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"cercles.xml"]];    
    tbxml = [[TBXML alloc] initWithXMLData:data error:&error];

    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handleNames:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] toArray:arrayCercles];
    }
    
    // Initialisation des fichiers TBXML avec le chemin de la sauvegarde interne
    NSData * data2 = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"clubs.xml"]];    
	tbxml = [[TBXML alloc] initWithXMLData:data2 error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handleNames:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] toArray:arrayClubs];
    }
    
    // Initialisation des fichiers TBXML avec le chemin de la sauvegarde interne
    NSData * data3 = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"types.xml"]]; 
    tbxml = [[TBXML alloc] initWithXMLData:data3 error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handleNames:[TBXML childElementNamed:@"taxonomy_term_data" parentElement:tbxml.rootXMLElement] toArray:arrayTypes];
    }
}

@end
