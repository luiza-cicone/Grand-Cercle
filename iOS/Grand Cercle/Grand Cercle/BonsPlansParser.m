//
//  BonsPlansParser.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 30/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "BonsPlansParser.h"

@implementation BonsPlansParser

static BonsPlansParser *instanceBonsPlans = nil;
@synthesize arrayBonsPlans;

// singleton
+ (BonsPlansParser *) instance {
    if (instanceBonsPlans == nil) {
        instanceBonsPlans = [[self alloc] init];
    }
    return instanceBonsPlans;
}

- (void) treatementBonsPlans:(TBXMLElement *)bonsPlansAParser {
	do {
        
        // Définition de la news à récupérer
        BonsPlans *aBonsPlans = [[BonsPlans alloc] init];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:bonsPlansAParser];
        aBonsPlans.title = [[TBXML textForElement:title]  stringByConvertingHTMLToPlainText];
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:bonsPlansAParser];
        aBonsPlans.description = [[TBXML textForElement:description]  stringByConvertingHTMLToPlainText];
        
        // Récupération du lien
        TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:bonsPlansAParser];
        aBonsPlans.theLink = (NSURL*)[[TBXML textForElement:link] stringByConvertingHTMLToPlainText];
        
        // Récupération du logo
        TBXMLElement *logo = [TBXML childElementNamed:@"image" parentElement:bonsPlansAParser];
        aBonsPlans.logo = (NSURL*)[[TBXML textForElement:logo]  stringByConvertingHTMLToPlainText];
        
        // Ajout de la news au tableau
        [arrayBonsPlans addObject:aBonsPlans];
        [aBonsPlans release];
        
	} while ((bonsPlansAParser = bonsPlansAParser->nextSibling));
}

- (void)loadBonsPlans { 
    
    // Initialisation du tableau contenant les News
    arrayBonsPlans = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Create a success block to be called when the async request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self treatementBonsPlans:tbxmlDocument.rootXMLElement->firstChild];
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/bons-plans/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];
        
}


@end


