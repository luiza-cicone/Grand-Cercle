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
    // Tableau contenant les noms des cercles, clubs et associations
	NSMutableArray *arrayCercles, *arrayClubs, *arrayTypes;
}

@property (nonatomic, retain) NSMutableArray *arrayCercles, *arrayClubs, *arrayTypes;

// Patron singleton, retourne l'unique instance du parser des noms des cercles, clubs et associations
+ (FilterParser *) instance;
// Méthode récupérant l'ensemble des noms des cercles, clubs et associations depuis le site
- (void)loadStuffFromURL;
// Méthode récupérant l'ensemble des noms des cercles, clubs et associations depuis une sauvegarde locale
- (void)loadStuffFromFile;
// Méthode appelée par les autres pour récupérer les informations nécéssaires
- (void) handleNames:(TBXMLElement *)listNamesToParse toArray:(NSMutableArray *) array;

@end
