//
//  BonsPlansParser.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 30/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deals.h"
#import "TBXML+HTTP.h"
#import "TBXML.h"
#import "NSString+HTML.h"

@interface DealsParser : NSObject {
    // Parser
    TBXML *tbxml;
    // Tableau contenant les bons plans
    NSMutableArray *arrayDeals;
}

@property(nonatomic, retain) NSMutableArray *arrayDeals;

// Patron singleton, retourne l'unique instance du parser de bons plans
+ (DealsParser *) instance;
// Méthode récupérant l'ensemble des bons plans depuis le site
- (void) loadDealsFromURL;
// Méthode récupérant l'ensemble des bons plans depuis une sauvegarde locale
- (void) loadDealsFromFile;
// Méthode appelée par les autres pour récupérer les informations nécéssaires
- (void) handleDeals:(TBXMLElement *)dealsToParse;

@end