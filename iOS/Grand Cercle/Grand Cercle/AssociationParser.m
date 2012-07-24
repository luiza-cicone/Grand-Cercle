//
//  AssociationParser.m
//  Grand Cercle
//
//  Created by Luiza Cicone on 23/7/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "AssociationParser.h"
#import "Association.h"
#import "AppDelegate.h"

@implementation AssociationParser

static AssociationParser *instanceNews = nil;

/**************************************************
 * Méthode retournant l'unique instance du parser *
 **************************************************/
+ (AssociationParser *) instance {
    if (instanceNews == nil) {
        instanceNews = [[self alloc] init];
    }
    return instanceNews;
}

/***************************************************
 * Méthode récupérant les informations nécessaires *
 **************************************************/
- (void) handle:(TBXMLElement *)objectToParse {
    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    // Tant qu'il y a une news à traiter
	do {
        // Initialisation de la news à récupérer
        Association *anAssos = [NSEntityDescription insertNewObjectForEntityForName:@"Association" inManagedObjectContext:managedObjectContext];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"id" parentElement:objectToParse];
        anAssos.idAssos = [NSNumber numberWithInt:[[[TBXML textForElement:title] stringByConvertingHTMLToPlainText] intValue]];
        
        // Récupération de la description
        TBXMLElement *content = [TBXML childElementNamed:@"group" parentElement:objectToParse];
        anAssos.name = [[TBXML textForElement:content] stringByDecodingHTMLEntities];
        
        // Récupération de la date de publication
        TBXMLElement *pubDate = [TBXML childElementNamed:@"logo" parentElement:objectToParse];
        anAssos.imagePath = [[TBXML textForElement:pubDate] stringByConvertingHTMLToPlainText];
        
        anAssos.type = [NSNumber numberWithInt:1];
        
        NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        
	} while ((objectToParse = objectToParse->nextSibling));
}

/***************************************************
 * Méthode de parsage des données du site internet *
 **************************************************/
- (void)loadFromURL { 
    
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handle:tbxmlDocument.rootXMLElement->firstChild];
    };
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialisation d'un objet TBXML avec le lien du fichier xml à parser
    tbxml = [[TBXML alloc] initWithURL: [NSURL URLWithString:@"http://www.grandcercle.org/xml/cercles.xml"] 
                               success: successBlock 
                               failure: failureBlock];
}

@end