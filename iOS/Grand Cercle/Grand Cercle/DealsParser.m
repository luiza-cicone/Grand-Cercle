//
//  BonsPlansParser.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 30/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "DealsParser.h"
#import "AppDelegate.h"


@implementation DealsParser
@synthesize managedObjectContext;

static DealsParser *instanceBonsPlans = nil;

+ (DealsParser *) instance {
    if (instanceBonsPlans == nil) {
        instanceBonsPlans = [[self alloc] init];
    }
    return instanceBonsPlans;
}

/***************************************************
 * Méthode récupérant les informations nécessaires *
 **************************************************/
- (void) handle:(TBXMLElement *)dealsToParse {
    
    // Tant qu'il y a une news à traiter
	do {
        
        // Test if the news is already in the DB
        NSFetchRequest *requestDeal = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *dealEntity = [NSEntityDescription entityForName:@"Deal" inManagedObjectContext:managedObjectContext];
        [requestDeal setEntity:dealEntity];
        
        TBXMLElement *idDeal = [TBXML childElementNamed:@"id" parentElement:dealsToParse];
        NSPredicate *dealIdPredicate = [NSPredicate predicateWithFormat:@"idDeal = %@", [TBXML textForElement:idDeal]];
        [requestDeal setPredicate:dealIdPredicate];        
        
        NSError *error = nil;
        
        NSArray *deals = [managedObjectContext executeFetchRequest:requestDeal error:&error];
        if (deals != nil && error == nil) {
            if([deals count] != 0)
                continue;
        }

        // Initialisation de la news à récupérer
        Deal *aDeal = [NSEntityDescription insertNewObjectForEntityForName:@"Deal" inManagedObjectContext:managedObjectContext];
        
        aDeal.idDeal = [NSNumber numberWithInt:[[TBXML textForElement:idDeal] intValue]];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:dealsToParse];
        aDeal.title = [[TBXML textForElement:title]  stringByConvertingHTMLToPlainText];
        
        // Récupération du sommaire
        TBXMLElement *summary = [TBXML childElementNamed:@"subtitle" parentElement:dealsToParse];
        aDeal.subtitle = [[TBXML textForElement:summary]  stringByConvertingHTMLToPlainText];   
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:dealsToParse];
        aDeal.content = [[TBXML textForElement:description] stringByDecodingHTMLEntities];
        
        // Récupération du logo
        TBXMLElement *logo = [TBXML childElementNamed:@"image" parentElement:dealsToParse];
        aDeal.image = [[TBXML textForElement:logo]  stringByConvertingHTMLToPlainText];
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
	} while ((dealsToParse = dealsToParse->nextSibling));
}

- (void)loadFromURL { 
    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    // Si le lien du fichier xml est correct, ce block est appelé
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handle:tbxmlDocument.rootXMLElement->firstChild];
    };
    
    // Si le lien du fichier xml est incorrect, ce block est appelé
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialisation d'un objet TBXML avec le lien du fichier xml à parser
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:kDealsURL]
                               success:successBlock 
                               failure:failureBlock];
}

-(void) loadFromFile {
    
    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // Initialisation des fichiers TBXML avec le chemin de la sauvegarde interne
    NSError *error = nil;
    
    tbxml = [[TBXML alloc] initWithXMLFile:@"deals.xml" error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handle:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement]];
    }
    [tbxml release];
    
}

@end
