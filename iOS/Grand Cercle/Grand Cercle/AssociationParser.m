//
//  AssociationParser.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "AssociationParser.h"

@implementation AssociationParser
@synthesize arrayClubs, arrayCercles;
static AssociationParser *instanceAssociation = nil;

// singleton
+ (AssociationParser *) instance {
    if (instanceAssociation == nil) {
        instanceAssociation = [[self alloc] init];
    }
    return instanceAssociation;
}

- (void) handleAssociations:(TBXMLElement *)eventsToParse toArray:(NSMutableArray *)array {
    
	do {
        // Récupération du nom de l'association
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:eventsToParse];
        NSString *nomAssociation = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];
        
        // Ajout de la news au tableau
        [array addObject:nomAssociation];
        [nomAssociation release]; 
        
        // Obtain next sibling element
	} while ((eventsToParse = eventsToParse->nextSibling));
    
}

- (void)loadAssociations { 
    
    // Initialisation du tableau contenant les News
    arrayCercles = [[NSMutableArray alloc] initWithCapacity:10];
    arrayClubs = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Create a success block to be called when the async request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleAssociations:tbxmlDocument.rootXMLElement->firstChild toArray:arrayCercles];
    };
    TBXMLSuccessBlock successBlock2 = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleAssociations:tbxmlDocument.rootXMLElement->firstChild toArray:arrayClubs];
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/cercles/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/clubs/data.xml"] 
                               success:successBlock2 
                               failure:failureBlock];
}
@end

