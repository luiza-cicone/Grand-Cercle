//
//  EvenementsParser.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventsParser.h"

@implementation EventsParser
@synthesize arrayEvents, arrayOldEvents;

// Patron singleton, unique instance du parser d'événements
static EventsParser *instanceEvent = nil;

/*********************************************************************************
 * Patron singleton, méthode retournant l'unique instance du parser d'événements *
 ********************************************************************************/
+ (EventsParser *) instance {
    if (instanceEvent == nil) {
        instanceEvent = [[self alloc] init];
    }
    return instanceEvent;
}

/***************************************************
 * Méthode récupérant les informations nécessaires *
 **************************************************/
- (void) handleEvents:(TBXMLElement *)eventsToParse toArray:(NSMutableArray *) array withFilter:(BOOL) filter {
    // Tant qu'il y a un événement à traiter
	do {
        
        // Récupération des préférences utilisateur concernant le filtre d'événements
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];        
        NSDictionary *filtreCercles = [defaults objectForKey:@"filtreCercles"]; 
        NSDictionary *filtreClubs = [defaults objectForKey:@"filtreClubs"]; 
        NSDictionary *filtreTypes = [defaults objectForKey:@"filtreTypes"]; 
        
        // Récupération de l'association qui organise et du type d'événement
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:eventsToParse];
        TBXMLElement *type = [TBXML childElementNamed:@"type" parentElement:eventsToParse];
        NSString *groupString = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];
        NSString *typeString = [[TBXML textForElement:type] stringByConvertingHTMLToPlainText];
        
        if (filter) {
            // On récupére automatiquement les informations si c'est un événement GC ou Élus étudiants
            // Si un événement ne correspond pas au filtre, on saute à la fin du bloc
            if (![groupString isEqualToString:@"Grand Cercle"] && ![groupString isEqualToString:@"Elus étudiants"]) {
                if (![[filtreCercles objectForKey:groupString] boolValue] && ![[filtreClubs objectForKey:[TBXML textForElement:group]] boolValue])
                    continue;
                if (![[filtreTypes objectForKey:typeString] boolValue]) {
                    continue;
                }
            }
        }
        
        // Définition de l'événement à récupérer
        Events *aEvent = [[Events alloc] init];
        
        // Récupération du type
        aEvent.type = [[TBXML textForElement:type] stringByConvertingHTMLToPlainText];
        
        // Récupération du groupe
        aEvent.group = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:eventsToParse];
        aEvent.title = [[TBXML textForElement:title] stringByConvertingHTMLToPlainText];
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:eventsToParse];
        aEvent.description = [[TBXML textForElement:description] stringByDecodingHTMLEntities];

        // Récupération du lien
        TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:eventsToParse];
        aEvent.theLink = [[TBXML textForElement:link] stringByConvertingHTMLToPlainText];
        
        // Récupération de la date de publication
        TBXMLElement *pubDate = [TBXML childElementNamed:@"pubDate" parentElement:eventsToParse];
        aEvent.pubDate = [[TBXML textForElement:pubDate] stringByConvertingHTMLToPlainText];
        
        // Récupération de l'auteur
        TBXMLElement *author = [TBXML childElementNamed:@"author" parentElement:eventsToParse];
        aEvent.author = [[TBXML textForElement:author] stringByConvertingHTMLToPlainText];
        
        // Récupération du logo
        TBXMLElement *logo = [TBXML childElementNamed:@"logo" parentElement:eventsToParse];
        aEvent.logo = [[TBXML textForElement:logo] stringByConvertingHTMLToPlainText];
        
        // Récupération du jour
        TBXMLElement *day = [TBXML childElementNamed:@"day" parentElement:eventsToParse];
        aEvent.day = [[TBXML textForElement:day] stringByConvertingHTMLToPlainText];
        
        // Récupération de la date
        TBXMLElement *date = [TBXML childElementNamed:@"date" parentElement:eventsToParse];
        aEvent.date = [[TBXML textForElement:date] stringByConvertingHTMLToPlainText];

        // Récupération de l'heure du début
        TBXMLElement *time = [TBXML childElementNamed:@"time" parentElement:eventsToParse];
        aEvent.time = [[TBXML textForElement:time] stringByConvertingHTMLToPlainText];

        // Récupération de la petite image
        TBXMLElement *imageSmall = [TBXML childElementNamed:@"thumbnail" parentElement:eventsToParse];
        aEvent.imageSmall = [[TBXML textForElement:imageSmall] stringByConvertingHTMLToPlainText];

        // Récupération de la petite image
        TBXMLElement *image = [TBXML childElementNamed:@"image" parentElement:eventsToParse];
        aEvent.image = [[TBXML textForElement:image] stringByConvertingHTMLToPlainText];

        // Récupération du lieu
        TBXMLElement *place = [TBXML childElementNamed:@"lieu" parentElement:eventsToParse];
        aEvent.place = [[TBXML textForElement:place] stringByConvertingHTMLToPlainText];

        // Récupération du la date
        TBXMLElement *eventDate = [TBXML childElementNamed:@"eventDate" parentElement:eventsToParse];        
        NSString *data = [[TBXML textForElement:eventDate] stringByConvertingHTMLToPlainText];
        data = [data stringByAppendingString:@" 00:00:00 +0000"];
        NSDateFormatter* firstDateFormatter = [[NSDateFormatter alloc] init];
        [firstDateFormatter setDateFormat:@"dd-MM-yy hh:mm:ss zzz"];
       
        aEvent.eventDate = [firstDateFormatter dateFromString:data];
        [aEvent.eventDate retain];
        
        // Ajout de l'événement dans le tableau
        [array addObject:aEvent];
        [firstDateFormatter release];
        [aEvent release];
        // Obtain next sibling element
	} while ((eventsToParse = eventsToParse->nextSibling));
    
}

/***************************************************
 * Méthode de parsage des données du site internet *
 **************************************************/
- (void)loadEventsFromURL { 
    
    // Initialisation des tableaux contenant les événements
    arrayEvents = [[NSMutableArray alloc] initWithCapacity:10];
    arrayOldEvents = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Si le premier lien du fichier xml est correct, ce block est appelé
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handleEvents:tbxmlDocument.rootXMLElement->firstChild toArray:arrayEvents withFilter:1];
    };
    
    // Si le deuxième lien du fichier xml est correct, ce block est appelé
    TBXMLSuccessBlock successBlock2 = ^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement)
            [self handleEvents:tbxmlDocument.rootXMLElement->firstChild toArray:arrayOldEvents withFilter:1];
    };
    
    // Si un des liens des fichiers xml est incorrect, ce block est appelé
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialisation de deux objets TBXML avec les liens des fichiers xml à parser
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/evenements/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/evenements-old/data.xml"] 
                               success:successBlock2 
                               failure:failureBlock];
}

/***********************************************************
 * Méthode de parsage des données de la sauvegarde interne *
 **********************************************************/
-(void) loadEventsFromFile {
    
    // Initialisation des tableaux contenant les événements
    arrayEvents = [[NSMutableArray alloc] initWithCapacity:10];
    arrayOldEvents = [[NSMutableArray alloc] initWithCapacity:10];

    // Récupération du chemin de la sauvegarde interne
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Initialisation du fichier TBXML avec le chemin de la sauvegarde interne
    NSError *error = nil;
    NSData * data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"evenements.xml"]];    
	tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handleEvents:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] toArray:arrayEvents withFilter:1];
    }
    
    // Initialisation du fichier TBXML avec le chemin de la sauvegarde interne
    NSData * data2 = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"evenements-old.xml"]];    
    
    tbxml = [[TBXML alloc] initWithXMLData:data2 error:&error];

    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handleEvents:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] toArray:arrayOldEvents withFilter:1];
    }
    
    // notification a la fin pour recharger la vue
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:self];
}

/****************************************************************************************
 * Méthode de parsage des données a partir d'un string utilisé pour les tests unitaires *
 ***************************************************************************************/
-(void) loadEventsFromString: (NSString *) xmlString toArray: (NSMutableArray *) array {
    
    // Initialisation des tableaux contenant les événements
    
    NSError *error = nil;

	tbxml = [[TBXML alloc] initWithXMLString:xmlString error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur    
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handleEvents:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] toArray:array withFilter:0];
    }
}

@end