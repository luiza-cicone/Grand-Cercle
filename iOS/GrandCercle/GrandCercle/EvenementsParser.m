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


- (void) treatementEvenements:(TBXMLElement *)eventAParser {
    
	do {
        
        // Définition de la news à récupérer
        Evenements *aEvent = [[Evenements alloc] init];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:eventAParser];
        aEvent.title = [TBXML textForElement:title];
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:eventAParser];
        aEvent.description = [TBXML textForElement:description];

                
        // Récupération du lien
        TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:eventAParser];
        aEvent.theLink = (NSURL*)[TBXML textForElement:link];

        
        // Récupération de la date de publication
        TBXMLElement *pubDate = [TBXML childElementNamed:@"pubDate" parentElement:eventAParser];
        aEvent.pubDate = [TBXML textForElement:pubDate];

        
        // Récupération de l'auteur
        TBXMLElement *author = [TBXML childElementNamed:@"author" parentElement:eventAParser];
        aEvent.author = [TBXML textForElement:author];

        
        // Récupération du groupe
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:eventAParser];
        aEvent.group = [TBXML textForElement:group];

        
        // Récupération du logo
        TBXMLElement *logo = [TBXML childElementNamed:@"logo" parentElement:eventAParser];
        aEvent.logo = (NSURL*)[TBXML textForElement:logo];

        
        // Récupération du jour
        TBXMLElement *day = [TBXML childElementNamed:@"day" parentElement:eventAParser];
        aEvent.day = [TBXML textForElement:day];

        
        // Récupération de la date
        TBXMLElement *date = [TBXML childElementNamed:@"date" parentElement:eventAParser];
        aEvent.date = [TBXML textForElement:date];

        
        // Récupération de l'heure du début
        TBXMLElement *time = [TBXML childElementNamed:@"time" parentElement:eventAParser];
        aEvent.time = [TBXML textForElement:time];

        
        // Récupération de la petite image
        TBXMLElement *imageSmall = [TBXML childElementNamed:@"thumbnail" parentElement:eventAParser];
        aEvent.imageSmall = (NSURL*)[TBXML textForElement:imageSmall];

        
        // Récupération du type
        TBXMLElement *type = [TBXML childElementNamed:@"type" parentElement:eventAParser];
        aEvent.type = [TBXML textForElement:type];

        
        // Récupération de la petite image
        TBXMLElement *image = [TBXML childElementNamed:@"image" parentElement:eventAParser];
        aEvent.image = (NSURL*)[TBXML textForElement:image];

        
        // Récupération du lieu
        TBXMLElement *place = [TBXML childElementNamed:@"lieu" parentElement:eventAParser];
        aEvent.place = [TBXML textForElement:place];

        
        // Récupération du prix avec CVA
        TBXMLElement *priceCVA = [TBXML childElementNamed:@"paf" parentElement:eventAParser];
        aEvent.priceCva = [TBXML textForElement:priceCVA];

        
        // Récupération du prix sans CVA
        TBXMLElement *priceNoCva = [TBXML childElementNamed:@"paf_sans_cva" parentElement:eventAParser];
        aEvent.priceNoCva = [TBXML textForElement:priceNoCva];
        
        // Ajout de la news au tableau
        [arrayEvenements addObject:aEvent];
        [aEvent release];
        
        // Obtain next sibling element
	} while ((eventAParser = eventAParser->nextSibling));
    
    NSLog(@"%d", [arrayEvenements count]);
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
