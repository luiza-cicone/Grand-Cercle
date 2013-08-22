//
//  EvenementsParser.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EventsParser.h"
#import "AppDelegate.h"
#import "Association.h"



@implementation EventsParser
@synthesize managedObjectContext;

static EventsParser *instanceEvent = nil;

+ (EventsParser *) instance {
    if (instanceEvent == nil) {
        instanceEvent = [[self alloc] init];
    }
    return instanceEvent;
}

/***************************************************
 * Méthode récupérant les informations nécessaires *
 **************************************************/
- (void) handle:(TBXMLElement *)eventsToParse {
    // Tant qu'il y a un événement à traiter
	do {
        
        // Test if the news is already in the DB
        NSFetchRequest *requestEvent = [[[NSFetchRequest alloc] init] autorelease];

        NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
        [requestEvent setEntity:eventEntity];

        TBXMLElement *idEvent = [TBXML childElementNamed:@"id" parentElement:eventsToParse];
        NSPredicate *eventIdPredicate = [NSPredicate predicateWithFormat:@"idEvent = %@", [TBXML textForElement:idEvent]];
        [requestEvent setPredicate:eventIdPredicate];

        NSError *error = nil;
        
        Event *anEvent;
        NSArray *events = [managedObjectContext executeFetchRequest:requestEvent error:&error];
        if (error == nil && events != nil )  {
            if([events count] > 0) {
                anEvent = [events objectAtIndex:0];
            }
            else {
                // Définition de l'événement à récupérer
                anEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
            }
        }
        else {
            NSLog(@"Error in EventsParser : handle: eventToParse ");
            continue;
        }

        anEvent.idEvent = [NSNumber numberWithInt:[[TBXML textForElement:idEvent] intValue]];
        
        // Récupération du type
        TBXMLElement *type = [TBXML childElementNamed:@"type" parentElement:eventsToParse];
        anEvent.type = [[TBXML textForElement:type] stringByConvertingHTMLToPlainText];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:eventsToParse];
        anEvent.title = [[TBXML textForElement:title] stringByConvertingHTMLToPlainText];
        
        TBXMLElement *promo = [TBXML childElementNamed:@"promo" parentElement:eventsToParse];
        NSString *promoStr = [[TBXML textForElement:promo] stringByConvertingHTMLToPlainText];
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:promoStr];
        NSInteger integer;
        if ([scanner scanInteger:&integer]) {
            anEvent.promo = [NSNumber numberWithInt:integer];;
        }
        else anEvent.promo = [NSNumber numberWithInt:0];
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:eventsToParse];
        anEvent.content = [[TBXML textForElement:description] stringByDecodingHTMLEntities];
        
        // Récupération de l'assos auteur
        TBXMLElement *author = [TBXML childElementNamed:@"author" parentElement:eventsToParse];
        
        NSEntityDescription *assosEntity = [NSEntityDescription entityForName:@"Association" inManagedObjectContext:managedObjectContext]; 
        NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
        NSPredicate *ofIdPredicate = [NSPredicate predicateWithFormat:@"idAssos = %@", [TBXML textForElement:author]];
        [request setEntity:assosEntity];
        [request setPredicate:ofIdPredicate];        
        
        error = nil;
        
        NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil && array.count > 0 && error == nil) {
            anEvent.author =  [array objectAtIndex:0];
        }
        else {
            NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
            [request2 setEntity:assosEntity];
            NSPredicate *gcPred = [NSPredicate predicateWithFormat:@"name = %@", kGrandCercle];
            [request2 setPredicate:gcPred];
            NSArray *array2 = [managedObjectContext executeFetchRequest:request2 error:&error];
            if (array2 != nil && array2.count > 0 && error == nil) {
                anEvent.author =  [array2 objectAtIndex:0];
            }
            else
                // normally never happens
                anEvent.author = [[Association alloc] init];
        }
    
        [request release];
        // Récupération du jour
        TBXMLElement *day = [TBXML childElementNamed:@"day" parentElement:eventsToParse];
        anEvent.day = [[TBXML textForElement:day] stringByConvertingHTMLToPlainText];
        
        // Récupération de la date
        TBXMLElement *date = [TBXML childElementNamed:@"date" parentElement:eventsToParse];
        anEvent.dateText = [[TBXML textForElement:date] stringByConvertingHTMLToPlainText];

        // Récupération de l'heure du début
        TBXMLElement *time = [TBXML childElementNamed:@"time" parentElement:eventsToParse];
        anEvent.time = [[TBXML textForElement:time] stringByConvertingHTMLToPlainText];

        // images
        TBXMLElement *imageSmall = [TBXML childElementNamed:@"thumb" parentElement:eventsToParse];
        anEvent.thumbnail = [[TBXML textForElement:imageSmall] stringByConvertingHTMLToPlainText];
        TBXMLElement *imageSmall2x = [TBXML childElementNamed:@"thumb2x" parentElement:eventsToParse];
        anEvent.thumbnail2x = [[TBXML textForElement:imageSmall2x] stringByConvertingHTMLToPlainText];

        TBXMLElement *image = [TBXML childElementNamed:@"image" parentElement:eventsToParse];
        anEvent.image = [[TBXML textForElement:image] stringByConvertingHTMLToPlainText];
        TBXMLElement *image2x= [TBXML childElementNamed:@"image2x" parentElement:eventsToParse];
        anEvent.image2x = [[TBXML textForElement:image2x] stringByConvertingHTMLToPlainText];\
        
        TBXMLElement *poster= [TBXML childElementNamed:@"poster" parentElement:eventsToParse];
        anEvent.poster = [[TBXML textForElement:poster] stringByConvertingHTMLToPlainText];
        TBXMLElement *poster2x= [TBXML childElementNamed:@"poster2x" parentElement:eventsToParse];
        anEvent.poster2x = [[TBXML textForElement:poster2x] stringByConvertingHTMLToPlainText];
        TBXMLElement *poster2xWide= [TBXML childElementNamed:@"poster2xWide" parentElement:eventsToParse];
        anEvent.poster2xWide = [[TBXML textForElement:poster2xWide] stringByConvertingHTMLToPlainText];

        TBXMLElement *place = [TBXML childElementNamed:@"location" parentElement:eventsToParse];
        anEvent.location = [[TBXML textForElement:place] stringByConvertingHTMLToPlainText];

        // Récupération du la date
        TBXMLElement *eventDate = [TBXML childElementNamed:@"formatter" parentElement:eventsToParse];        
        NSString *data = [[TBXML textForElement:eventDate] stringByConvertingHTMLToPlainText];
        data = [data stringByAppendingString:@" 00:00:00 +0000"];
        NSDateFormatter* firstDateFormatter = [[NSDateFormatter alloc] init];
        [firstDateFormatter setDateFormat:@"dd-MM-yy hh:mm:ss zzz"];
       
        anEvent.date = [firstDateFormatter dateFromString:data];
        [anEvent.date retain];
        
        [firstDateFormatter release];
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
	
    } while ((eventsToParse = eventsToParse->nextSibling));
    
}

/***************************************************
 * Méthode de parsage des données du site internet *
 **************************************************/
- (void)loadFromURL { 
    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    NSLog(@"EventsParser.loadFromURL : try to update events");

    /*  send a request for file modification date  */
    NSURLRequest *modReq = [NSURLRequest requestWithURL:[NSURL URLWithString:kEventsURL]
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
    NSURLResponse* response;
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:modReq returningResponse:&response error:&error];
    
    NSString * last_modified = [NSString stringWithFormat:@"%@",
                                [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Last-Modified"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![last_modified isEqualToString:[defaults stringForKey:@"last-modified"]]) {
        
        NSLog(@"EventsParser.loadFromURL : updating events");

        [defaults setObject:last_modified forKey:@"last-modified"];

        // Si le premier lien du fichier xml est correct, ce block est appelé
        TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
            if (tbxmlDocument.rootXMLElement)
                [self handle:tbxmlDocument.rootXMLElement->firstChild];
        };
        
        // Si un des liens des fichiers xml est incorrect, ce block est appelé
        TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
            NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        };
        
        // Initialisation de deux objets TBXML avec les liens des fichiers xml à parser
        tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:kEventsURL] 
                                   success:successBlock 
                                   failure:failureBlock];
        
        NSLog(@"EventsParser.loadFromURL : finished updating events");
    }

}

-(void) loadFromFile {
    NSLog(@"EventsParser.loadFromFile");

    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // Initialisation des fichiers TBXML avec le chemin de la sauvegarde interne
    NSError *error = nil;
    
    tbxml = [[TBXML alloc] initWithXMLFile:@"events.xml" error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handle:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement]];
    }
    [tbxml release];
    NSLog(@"EventsParser.loadFromFile : finished loading events");

}


@end