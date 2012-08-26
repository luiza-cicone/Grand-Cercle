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
#import "FilterParser.h"

@implementation AssociationParser

@synthesize imageCache;

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
- (void) handle:(TBXMLElement *)objectToParse ofType:(int)type {
    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    // Tant qu'il y a une news à traiter
	do {
        
        // Test if the news is already in the DB
        NSFetchRequest *requestAssos = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *assosEntity = [NSEntityDescription entityForName:@"Association" inManagedObjectContext:managedObjectContext];
        [requestAssos setEntity:assosEntity];
        
        TBXMLElement *idAssos = [TBXML childElementNamed:@"id" parentElement:objectToParse];
        NSPredicate *assosIdPredicate = [NSPredicate predicateWithFormat:@"idAssos = %@", [TBXML textForElement:idAssos]];
        [requestAssos setPredicate:assosIdPredicate];        
        
        NSError *error = nil;
        
        NSArray *assos = [managedObjectContext executeFetchRequest:requestAssos error:&error];
        if (assos != nil && error == nil) {
            if([assos count] != 0)
                continue;
        } else {
            // Deal with error.
            continue;
        }
        
        // Initialisation de la news à récupérer
        Association *anAssos = [NSEntityDescription insertNewObjectForEntityForName:@"Association" inManagedObjectContext:managedObjectContext];
        
        // Récupération du titre
        anAssos.idAssos = [NSNumber numberWithInt:[[[TBXML textForElement:idAssos] stringByConvertingHTMLToPlainText] intValue]];
        
        // Récupération de la description
        TBXMLElement *name = [TBXML childElementNamed:@"group" parentElement:objectToParse];
        anAssos.name = [[TBXML textForElement:name] stringByDecodingHTMLEntities];
        
        NSArray *arrayTypes = [[FilterParser instance] arrayTypes];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *cerclesDico = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"filtreCercles"]];
        if (cerclesDico == nil) {
            cerclesDico = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *typesDico = [cerclesDico objectForKey:anAssos.name];
            
            if (typesDico == nil) {
                NSMutableDictionary *typesDico = [[NSMutableDictionary alloc] init];
                for (NSString *type in arrayTypes) {
                    [typesDico setValue:[NSNumber numberWithBool:YES] forKey:type];
                }
                [cerclesDico setValue:typesDico forKey:anAssos.name];
                [typesDico release];
            }
            [defaults setObject:cerclesDico forKey:@"filtreCercles"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [cerclesDico release];
        }
        
        
        // Récupération de la date de publication
        TBXMLElement *logo = [TBXML childElementNamed:@"logo" parentElement:objectToParse];
        anAssos.imagePath = [[TBXML textForElement:logo] stringByConvertingHTMLToPlainText];
        
        if (![anAssos.imagePath isEqualToString:@""]) {
            // test si c'est dans le cache
            NSString *imageKey = [NSString stringWithFormat:@"%x", [anAssos.imagePath hash]];
            
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *imagePath = [[documentsDirectory stringByAppendingPathComponent:@"images/assos"] stringByAppendingPathComponent:imageKey];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
            
            if (!fileExists) {
                // download img async
                [imageCache imageForKey:imageKey url:[NSURL URLWithString:anAssos.imagePath] queueIfNeeded:YES tag:[anAssos.idAssos intValue]];
            }
        }
        
        anAssos.type = [NSNumber numberWithInt:type];
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        
	} while ((objectToParse = objectToParse->nextSibling));
}

/***************************************************
 * Méthode de parsage des données du site internet *
 **************************************************/
- (void)loadFromURL { 

    self.imageCache = [[[TKImageCache alloc] initWithCacheDirectoryName:@"images/assos"] autorelease];
    self.imageCache.notificationName = @"newAssosImage";
    
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handle:tbxmlDocument.rootXMLElement->firstChild ofType:1];
    };
    
    TBXMLSuccessBlock successBlock2 = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handle:tbxmlDocument.rootXMLElement->firstChild ofType:2];
    };
    
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialisation d'un objet TBXML avec le lien du fichier xml à parser
    tbxml = [[TBXML alloc] initWithURL: [NSURL URLWithString:@"http://www.grandcercle.org/xml/cercles.xml"] 
                               success: successBlock 
                               failure: failureBlock];
    [tbxml release];
    // Initialisation d'un objet TBXML avec le lien du fichier xml à parser
    tbxml = [[TBXML alloc] initWithURL: [NSURL URLWithString:@"http://www.grandcercle.org/xml/clubs.xml"] 
                               success: successBlock2 
                               failure: failureBlock];
    [tbxml release];
}

- (void)loadFromFile { 

    // Initialisation des fichiers TBXML avec le chemin de la sauvegarde interne
    NSError *error = nil;
    
    tbxml = [[TBXML alloc] initWithXMLFile:@"cercles.xml" error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handle:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] ofType:1];
    }
    [tbxml release];
    
    tbxml = [[TBXML alloc] initWithXMLFile:@"clubs.xml" error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handle:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] ofType:2];
    }
}

@end