//
//  EvenementsParser.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EvenementsParser.h"

@implementation EvenementsParser
@synthesize arrayEvents, arrayOldEvents;
static EvenementsParser *instanceEvent = nil;

// singleton
+ (EvenementsParser *) instance {
    if (instanceEvent == nil) {
        instanceEvent = [[self alloc] init];
    }
    return instanceEvent;
}

- (void) handleEvents:(TBXMLElement *)eventsToParse toArray:(NSMutableArray *)array {
    
    NSInteger indice = 0;
    
	do {
        
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:eventsToParse];
        TBXMLElement *type = [TBXML childElementNamed:@"type" parentElement:eventsToParse];
        
        // Récupération des préférences
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];        
        NSDictionary *filtreCercles = [defaults objectForKey:@"filtreCercles"]; 
        NSDictionary *filtreClubs = [defaults objectForKey:@"filtreClubs"]; 
        NSDictionary *filtreTypes = [defaults objectForKey:@"filtreTypes"]; 
        
        NSString *groupString = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];
        NSString *typeString = [[TBXML textForElement:type] stringByConvertingHTMLToPlainText];
        if (![groupString isEqualToString:@"Grand Cercle"] && ![groupString isEqualToString:@"Elus étudiants"]) {
            if (![[filtreCercles objectForKey:groupString] boolValue] && ![[filtreClubs objectForKey:[TBXML textForElement:group]] boolValue])
                continue;
            if (![[filtreTypes objectForKey:typeString] boolValue]) {
                continue;
            }
        }
        
        // Définition de l'événement à récupérer
        Evenements *aEvent = [[Evenements alloc] init];
        
        // Récupération du type
        aEvent.type = [[TBXML textForElement:type] stringByConvertingHTMLToPlainText];
            
        // Récupération du groupe
        aEvent.group = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:eventsToParse];
        aEvent.title = [[TBXML textForElement:title] stringByConvertingHTMLToPlainText];
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:eventsToParse];
        aEvent.description = [[TBXML textForElement:description] stringByConvertingHTMLToPlainText];

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

        // Récupération du prix avec CVA
        TBXMLElement *priceCVA = [TBXML childElementNamed:@"paf" parentElement:eventsToParse];
        aEvent.priceCva = [[TBXML textForElement:priceCVA] stringByConvertingHTMLToPlainText];

        // Récupération du prix sans CVA
        TBXMLElement *priceNoCva = [TBXML childElementNamed:@"paf_sans_cva" parentElement:eventsToParse];
        aEvent.priceNoCva = [[TBXML textForElement:priceNoCva] stringByConvertingHTMLToPlainText];
  
        // Récupération du la date
        TBXMLElement *eventDate = [TBXML childElementNamed:@"eventDate" parentElement:eventsToParse];        
        NSString *data = [[TBXML textForElement:eventDate] stringByConvertingHTMLToPlainText];
        data = [data stringByAppendingString:@" 00:00:00 +0000"];
        NSDateFormatter* firstDateFormatter = [[NSDateFormatter alloc] init];
        [firstDateFormatter setDateFormat:@"dd-MM-yy hh:mm:ss zzz"];
        aEvent.eventDate = [firstDateFormatter dateFromString:data];
        [aEvent.eventDate retain];

        // Indication de l'indice
        aEvent.indice = indice;
        indice++;
        
        // Ajout de la news au tableau
        [array addObject:aEvent];
        [firstDateFormatter release];
        [aEvent release];
        

        // Obtain next sibling element
	} while ((eventsToParse = eventsToParse->nextSibling));
    
}

- (void)loadEvenements { 
    
    // Initialisation du tableau contenant les News
    arrayEvents = [[NSMutableArray alloc] initWithCapacity:10];
    arrayOldEvents = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Create a success block to be called when the async request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleEvents:tbxmlDocument.rootXMLElement->firstChild toArray:arrayEvents];
    };
    TBXMLSuccessBlock successBlock2 = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleEvents:tbxmlDocument.rootXMLElement->firstChild toArray:arrayOldEvents];
    };
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/evenements/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/evenements/data-old.xml"] 
                               success:successBlock2 
                               failure:failureBlock];
}
@end
