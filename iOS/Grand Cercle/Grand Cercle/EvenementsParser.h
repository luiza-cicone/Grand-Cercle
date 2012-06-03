//
//  EvenementsParser.h
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML+HTTP.h"
#import "TBXML.h"
#import "NSString+HTML.h"
#import "Evenements.h"

@interface EvenementsParser : NSObject {
    // Parser
    TBXML *tbxml;
    // Ensemble des Evénements
	NSMutableArray *arrayEvents, *arrayOldEvents;
}

@property (nonatomic, retain) NSMutableArray *arrayEvents, *arrayOldEvents;

// Unique instance du parser
+ (EvenementsParser *) instance;
// Méthode récupérant l'ensemble des news
- (void)loadEvenements;
- (void) handleEvents:(TBXMLElement *)eventsToParse toArray:(NSMutableArray *) array;

@end
