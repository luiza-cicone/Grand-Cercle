//
//  AssociationParser.m
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "FilterParser.h"

@implementation FilterParser
@synthesize arrayClubs, arrayCercles, arrayTypes;
static FilterParser *instanceAssociation = nil;
// singleton
+ (FilterParser *) instance {
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
        
        
        // Obtain next sibling element
	} while ((eventsToParse = eventsToParse->nextSibling));
    
}

- (void)loadAssociations { 
    
    // Initialisation du tableau contenant les News
    arrayCercles = [[NSMutableArray alloc] initWithCapacity:3];
    arrayClubs = [[NSMutableArray alloc] initWithCapacity:3];
    arrayTypes = [[NSMutableArray alloc] initWithCapacity:3];
    
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
    TBXMLSuccessBlock successBlock3 = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleAssociations:tbxmlDocument.rootXMLElement->firstChild toArray:arrayTypes];
    };
    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIAlertView *xmlError = [[UIAlertView alloc] initWithTitle:@"Erreur"
                                              message:@"Une erreur a intervenu dans la mise a jour des informations"
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:@"Reesayer", nil];
        [xmlError show];
        });
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);

    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/cercles/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/clubs/data.xml"] 
                               success:successBlock2 
                               failure:failureBlock];
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/types/data.xml"] 
                                   success:successBlock3 
                                   failure:failureBlock];   

    
}
#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self loadAssociations];
    }
}
@end

