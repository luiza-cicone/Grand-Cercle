//
//  AssociationParser.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "FilterParser.h"

#import "NSString+HTML.h"
#import "TBXML+HTTP.h"

@implementation FilterParser
@synthesize arrayTypes;

static FilterParser *instanceAssociation = nil;

/**************************************************
 * Méthode retournant l'unique instance du parser *
 **************************************************/
+ (FilterParser *) instance {
    if (instanceAssociation == nil) {
        instanceAssociation = [[self alloc] init];
    }
    return instanceAssociation;
}

/***************************************************
 * Méthode récupérant les informations nécessaires *
 **************************************************/
- (void) handle:(TBXMLElement *)list {
    
    // Tant qu'il y a un événement à traiter
	do {
        
        // Récupération du nom du cercle, club ou d'association
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:list];
        NSString *nomAssociation = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];
        
        // Ajout du nom au tableau
        [arrayTypes addObject:nomAssociation];
        
	} while ((list = list->nextSibling));
}

/***************************************************
 * Méthode de parsage des données du site internet *
 **************************************************/
- (void)loadFromURL { 
    
    // Initialisation du tableau
    arrayTypes = [[NSMutableArray alloc] initWithCapacity:3];
    
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handle:tbxmlDocument.rootXMLElement->firstChild];
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
   
    tbxml = [[TBXML alloc] initWithURL: [NSURL URLWithString:@"http://www.grandcercle.org/types/data.xml"] 
                               success: successBlock 
                               failure: failureBlock];
}

/***********************************************************
 * Méthode de parsage des données de la sauvegarde interne *
 **********************************************************/
-(void) loadFromFile {
    
    // Initialisation du tableau contenant les noms
    arrayTypes = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Initialisation des fichiers TBXML avec le chemin de la sauvegarde interne
    NSError *error = nil;
    
    tbxml = [[TBXML alloc] initWithXMLFile:@"types.xml" error:&error];

    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        if (tbxml.rootXMLElement)
            [self handle:tbxml.rootXMLElement->firstChild];
    }
    
}

@end
