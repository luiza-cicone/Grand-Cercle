//
//  NewsParser.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "NewsParser.h"
#import "AppDelegate.h"
#import "Association.h"

@implementation NewsParser
//@synthesize arrayNews;

// Patron singleton, unique instance du parser de news
static NewsParser *instanceNews = nil;

/****************************************************************************
 * Patron singleton, méthode retournant l'unique instance du parser de news *
 ***************************************************************************/
+ (NewsParser *) instance {
    if (instanceNews == nil) {
        instanceNews = [[self alloc] init];
    }
    return instanceNews;
}

/***************************************************
 * Méthode récupérant les informations nécessaires *
 **************************************************/
- (void) handleNews:(TBXMLElement *)newsAParser {
    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }

    // Tant qu'il y a une news à traiter
	do {
        // Initialisation de la news à récupérer
        News *aNews = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:managedObjectContext];
        
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:newsAParser];
        aNews.title = [[TBXML textForElement:title] stringByConvertingHTMLToPlainText];
        
        // Récupération de la description
        TBXMLElement *content = [TBXML childElementNamed:@"description" parentElement:newsAParser];
        aNews.content = [[TBXML textForElement:content] stringByDecodingHTMLEntities];
        
        // Récupération de la date de publication
        TBXMLElement *pubDate = [TBXML childElementNamed:@"pubDate" parentElement:newsAParser];
        aNews.pubDate = [[TBXML textForElement:pubDate] stringByConvertingHTMLToPlainText];
        
        // Récupération du cercle ou club
        TBXMLElement *author = [TBXML childElementNamed:@"author" parentElement:newsAParser];
        
        NSEntityDescription *assosEntity = [NSEntityDescription entityForName:@"Association" inManagedObjectContext:managedObjectContext]; 
        NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
        NSPredicate *ofIdPredicate = [NSPredicate predicateWithFormat:@"idAssos = %@", [TBXML textForElement:author]];
        [request setEntity:assosEntity];
        [request setPredicate:ofIdPredicate];        
        NSError *error = nil;
        
        NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil && error == nil) {
//            [array retain];
            aNews.author =  [array objectAtIndex:0];
//            [array release];
        }
        else {
            // Deal with error.
        }
        
        // Récupération de l'image
        TBXMLElement *image = [TBXML childElementNamed:@"image" parentElement:newsAParser];
        aNews.image = [[TBXML textForElement:image]  stringByConvertingHTMLToPlainText];
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
	} while ((newsAParser = newsAParser->nextSibling));
}

/***************************************************
 * Méthode de parsage des données du site internet *
 **************************************************/
- (void)loadNewsFromURL { 
    
    // Initialisation du tableau contenant les News
//    arrayNews = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Si le lien du fichier xml est correct, ce block est appelé
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handleNews:tbxmlDocument.rootXMLElement->firstChild];
    };

    // Si le lien du fichier xml est incorrect, ce block est appelé
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialisation d'un objet TBXML avec le lien du fichier xml à parser
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/xml/news.xml"] 
                               success:successBlock 
                               failure:failureBlock];
}

///***********************************************************
// * Méthode de parsage des données de la sauvegarde interne *
// **********************************************************/
//-(void) loadNewsFromFile {
//    
//    // Initialisation du tableau contenant les News
//    arrayNews = [[NSMutableArray alloc] initWithCapacity:10];
//
//    // Récupération du chemin de la sauvegarde interne
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filename = @"news.xml";
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, filename];
//
//    // Initialisation du fichier TBXML avec le chemin de la sauvegarde interne
//    NSData * data = [NSData dataWithContentsOfFile:filePath];    
//    NSError *error = nil;
//	tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
//    
//    if (error) {
//        // Si l'initialisation s'est mal passée, on affiche l'erreur    
//        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
//    } else {
//        // Si aucune erreur n'est levée, on parse la sauvegarde interne
//        if (tbxml.rootXMLElement){
//                [self handleNews:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement]];
//        }
//    }
//}

@end