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

- (void) handleStuff:(TBXMLElement *)eventsToParse toArray:(NSMutableArray *)array {
    
	do {
        // Récupération du nom de l'association
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:eventsToParse];

        NSString *nomAssociation = [[TBXML textForElement:group] stringByConvertingHTMLToPlainText];
        
        // Ajout de la news au tableau
        [array addObject:nomAssociation];
        
        
        // Obtain next sibling element
	} while ((eventsToParse = eventsToParse->nextSibling));
    
}

- (void)loadStuffFromURL { 
    
    // Initialisation du tableau contenant les News
    arrayCercles = [[NSMutableArray alloc] initWithCapacity:3];
    arrayClubs = [[NSMutableArray alloc] initWithCapacity:3];
    arrayTypes = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Create a success block to be called when the async request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleStuff:tbxmlDocument.rootXMLElement->firstChild toArray:arrayCercles];
    };
    TBXMLSuccessBlock successBlock2 = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleStuff:tbxmlDocument.rootXMLElement->firstChild toArray:arrayClubs];
    };
    TBXMLSuccessBlock successBlock3 = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self handleStuff:tbxmlDocument.rootXMLElement->firstChild toArray:arrayTypes];
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
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/types/data.xml"] 
                                   success:successBlock3 
                                   failure:failureBlock];
}

-(void) loadStuffFromFile {
    arrayCercles = [[NSMutableArray alloc] initWithCapacity:3];
    arrayClubs = [[NSMutableArray alloc] initWithCapacity:3];
    arrayTypes = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    
    NSData * data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"cercles.xml"]];    
    NSData * data2 = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"clubs.xml"]];    
    NSData * data3 = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, @"types.xml"]];    
    
    // error var
	tbxml = [[TBXML alloc] initWithXMLData:data error:&error];
    
    // if an error occured, log it    
    if (error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        
    } else {
        
        // If TBXML found a root node, process element and iterate all children
        if (tbxml.rootXMLElement){
            [self handleStuff:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] toArray:arrayCercles];
        }
    }
    
    // error var
	tbxml = [[TBXML alloc] initWithXMLData:data2 error:&error];
    
    // if an error occured, log it    
    if (error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        
    } else {
        
        // If TBXML found a root node, process element and iterate all children
        if (tbxml.rootXMLElement){
            [self handleStuff:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement] toArray:arrayClubs];
        }
    }

    // error var
	tbxml = [[TBXML alloc] initWithXMLData:data3 error:&error];
    
    // if an error occured, log it    
    if (error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        
    } else {
        
        // If TBXML found a root node, process element and iterate all children
        if (tbxml.rootXMLElement){
            [self handleStuff:[TBXML childElementNamed:@"taxonomy_term_data" parentElement:tbxml.rootXMLElement] toArray:arrayTypes];
        }
    }

}

@end

