//
//  BonsPlansParser.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 30/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML+HTTP.h"
#import "TBXML.h"
#import "NSString+HTML.h"
#import "BonsPlans.h"

@interface BonsPlansParser : NSObject {
    // Parser
    TBXML *tbxml;
    // Ensemble des Bons Plans
    NSMutableArray *arrayBonsPlans;
}

@property(nonatomic, retain) NSMutableArray *arrayBonsPlans;

// Unique instance du parser
+ (BonsPlansParser *) instance;
// Méthode récupérant l'ensemble des bons plans
- (void) loadBonsPlans;
- (void) treatementBonsPlans:(TBXMLElement *)element;

@end






