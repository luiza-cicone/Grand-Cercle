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

@interface FilterParser : NSObject {
    // Parser
    TBXML *tbxml;
    // Ensemble des cercles et des clubs
	NSMutableArray *arrayCercles, *arrayClubs, *arrayTypes;
}

@property (nonatomic, retain) NSMutableArray *arrayCercles, *arrayClubs, *arrayTypes;


// Unique instance du parser
+ (FilterParser *) instance;
// Méthode récupérant l'ensemble des news
- (void)loadStuffFromURL;
- (void)loadStuffFromFile;
- (void) handleStuff:(TBXMLElement *)eventsToParse toArray:(NSMutableArray *) array;

@end

