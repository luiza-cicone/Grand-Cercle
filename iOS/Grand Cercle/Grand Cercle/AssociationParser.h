//
//  AssociationParser.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML+HTTP.h"
#import "TBXML.h"
#import "NSString+HTML.h"

@interface AssociationParser : NSObject {
    // Parser
    TBXML *tbxml;
    // Ensemble des cercles et des clubs
	NSMutableArray *arrayCercles, *arrayClubs;
}

@property (nonatomic, retain) NSMutableArray *arrayCercles, *arrayClubs;

    // Unique instance du parser
    + (AssociationParser *) instance;
    // Méthode récupérant l'ensemble des news
    - (void)loadAssociations;
    - (void) handleAssociations:(TBXMLElement *)eventsToParse toArray:(NSMutableArray *) array;

@end

