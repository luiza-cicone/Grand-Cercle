//
//  EvenementsParser.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "EvenementsParser.h"

@implementation EvenementsParser
@synthesize arrayEvenements;
static EvenementsParser *instanceEvent = nil;

// singleton
+ (EvenementsParser *) instance {
    if (instanceEvent == nil) {
        instanceEvent = [[self alloc] init];
    }
    return instanceEvent;
}

- (void) treatementEvenements:(TBXMLElement *)eventAParser {
    
    NSInteger indice = 0;
	do {
        
        // Définition de la news à récupérer
        Evenements *aEvent = [[Evenements alloc] init];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:eventAParser];
        aEvent.title = [[TBXML textForElement:title] stringByConvertingHTMLToPlainText];
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:eventAParser];
        aEvent.description = [[TBXML textForElement:description] stringByConvertingHTMLToPlainText];

                
        // Récupération du lien
        TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:eventAParser];
        aEvent.theLink = (NSURL*)[[TBXML textForElement:link] stringByConvertingHTMLToPlainText];

        
        // Récupération de la date de publication
        TBXMLElement *pubDate = [TBXML childElementNamed:@"pubDate" parentElement:eventAParser];
        aEvent.pubDate = [[TBXML textForElement:pubDate] stringByConvertingHTMLToPlainText];

        
        // Récupération de l'auteur
        TBXMLElement *author = [TBXML childElementNamed:@"author" parentElement:eventAParser];
        aEvent.author = [[TBXML textForElement:author] stringByConvertingHTMLToPlainText];

        
        // Récupération du groupe
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:eventAParser];
        aEvent.group = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];

        
        // Récupération du logo
        TBXMLElement *logo = [TBXML childElementNamed:@"logo" parentElement:eventAParser];
        aEvent.logo = (NSURL*)[[TBXML textForElement:logo] stringByConvertingHTMLToPlainText];

        
        // Récupération du jour
        TBXMLElement *day = [TBXML childElementNamed:@"day" parentElement:eventAParser];
        aEvent.day = [[TBXML textForElement:day] stringByConvertingHTMLToPlainText];

        
        // Récupération de la date
        TBXMLElement *date = [TBXML childElementNamed:@"date" parentElement:eventAParser];
        aEvent.date = [[TBXML textForElement:date] stringByConvertingHTMLToPlainText];

        
        // Récupération de l'heure du début
        TBXMLElement *time = [TBXML childElementNamed:@"time" parentElement:eventAParser];
        aEvent.time = [[TBXML textForElement:time] stringByConvertingHTMLToPlainText];

        
        // Récupération de la petite image
        TBXMLElement *imageSmall = [TBXML childElementNamed:@"thumbnail" parentElement:eventAParser];
        aEvent.imageSmall = (NSURL*)[[TBXML textForElement:imageSmall] stringByConvertingHTMLToPlainText];

        
        // Récupération du type
        TBXMLElement *type = [TBXML childElementNamed:@"type" parentElement:eventAParser];
        aEvent.type = [[TBXML textForElement:type] stringByConvertingHTMLToPlainText];

        
        // Récupération de la petite image
        TBXMLElement *image = [TBXML childElementNamed:@"image" parentElement:eventAParser];
        aEvent.image = (NSURL*)[[TBXML textForElement:image] stringByConvertingHTMLToPlainText];

        
        // Récupération du lieu
        TBXMLElement *place = [TBXML childElementNamed:@"lieu" parentElement:eventAParser];
        aEvent.place = [[TBXML textForElement:place] stringByConvertingHTMLToPlainText];

        
        // Récupération du prix avec CVA
        TBXMLElement *priceCVA = [TBXML childElementNamed:@"paf" parentElement:eventAParser];
        aEvent.priceCva = [[TBXML textForElement:priceCVA] stringByConvertingHTMLToPlainText];

        
        // Récupération du prix sans CVA
        TBXMLElement *priceNoCva = [TBXML childElementNamed:@"paf_sans_cva" parentElement:eventAParser];
        aEvent.priceNoCva = [[TBXML textForElement:priceNoCva] stringByConvertingHTMLToPlainText];
  
        // Récupération du la date
        TBXMLElement *eventDate = [TBXML childElementNamed:@"eventDate" parentElement:eventAParser];        
        NSString *data = [[TBXML textForElement:eventDate] stringByConvertingHTMLToPlainText];
        
        data = [data stringByAppendingString:@" 00:00:00 +0000"];
                
        NSDateFormatter* firstDateFormatter = [[NSDateFormatter alloc] init];
        [firstDateFormatter setDateFormat:@"dd-MM-yy hh:mm:ss zzz"];

        aEvent.eventDate = [firstDateFormatter dateFromString:data];
        NSLog(@"%@ - %@", aEvent.title, aEvent.eventDate);
        [aEvent.eventDate retain];

        // Indication de l'indice
        aEvent.indice = indice;
        indice++;
        
        // Ajout de la news au tableau
        [arrayEvenements addObject:aEvent];
        [aEvent release];
        [firstDateFormatter release];
        
        // Obtain next sibling element
	} while ((eventAParser = eventAParser->nextSibling));
    
}

- (void)loadEvenements { 
    
    // Initialisation du tableau contenant les News
    arrayEvenements = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Create a success block to be called when the async request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self treatementEvenements:tbxmlDocument.rootXMLElement->firstChild];
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/evenements/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];
    
}
@end
