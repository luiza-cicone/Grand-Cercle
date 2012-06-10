//
//  BonsPlansParser.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 30/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "DealsParser.h"

@implementation DealsParser
@synthesize arrayDeals;

// Patron singleton, unique instance du parser de news
static DealsParser *instanceBonsPlans = nil;

/**********************************************************************************
 * Patron singleton, méthode retournant l'unique instance du parser de bons plans *
 *********************************************************************************/
+ (DealsParser *) instance {
    if (instanceBonsPlans == nil) {
        instanceBonsPlans = [[self alloc] init];
    }
    return instanceBonsPlans;
}

/***************************************************
 * Méthode récupérant les informations nécessaires *
 **************************************************/
- (void) handleDeals:(TBXMLElement *)dealsToParse {
    
    // Tant qu'il y a une news à traiter
	do {
        
        // Initialisation du bon plan à récupérer
        Deals *aBonsPlans = [[Deals alloc] init];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:dealsToParse];
        aBonsPlans.title = [[TBXML textForElement:title]  stringByConvertingHTMLToPlainText];
        
        // Récupération du sommaire
        TBXMLElement *summary = [TBXML childElementNamed:@"summary" parentElement:dealsToParse];
        aBonsPlans.summary = [[TBXML textForElement:summary]  stringByConvertingHTMLToPlainText];   
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:dealsToParse];
        aBonsPlans.description = [[TBXML textForElement:description] stringByDecodingHTMLEntities];
        
        // Récupération du lien
        TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:dealsToParse];
        aBonsPlans.theLink = [[TBXML textForElement:link] stringByConvertingHTMLToPlainText];
        
        // Récupération du logo
        TBXMLElement *logo = [TBXML childElementNamed:@"image" parentElement:dealsToParse];
        aBonsPlans.logo = [[TBXML textForElement:logo]  stringByConvertingHTMLToPlainText];
        
        // Ajout du bon plan dans le tableau
        [arrayDeals addObject:aBonsPlans];
        [aBonsPlans release];
        
	} while ((dealsToParse = dealsToParse->nextSibling));
}

/***************************************************
 * Méthode de parsage des données du site internet *
 **************************************************/
- (void)loadDealsFromURL { 
    
    // Initialisation du tableau contenant les bons plans
    arrayDeals = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Si le lien du fichier xml est correct, ce block est appelé
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handleDeals:tbxmlDocument.rootXMLElement->firstChild];
    };
    
    // Si le lien du fichier xml est incorrect, ce block est appelé
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialisation d'un objet TBXML avec le lien du fichier xml à parser
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/bons-plans/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];
}

/***********************************************************
 * Méthode de parsage des données de la sauvegarde interne *
 **********************************************************/
-(void) loadDealsFromFile {
    
    // Initialisation du tableau contenant les News
    arrayDeals = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Récupération du chemin de la sauvegarde interne
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = @"bons-plans.xml";
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
    
    // Initialisation du fichier TBXML avec le chemin de la sauvegarde interne
    NSError *error = nil;
    NSData * data = [NSData dataWithContentsOfFile:filePath];    
	tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement){
            [self handleDeals:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement]];
        }
    }
}

@end
