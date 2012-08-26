//
//  AssociationParser.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 04/06/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface FilterParser : NSObject {
    TBXML *tbxml;
	NSMutableArray *arrayTypes;
}

@property (nonatomic, retain) NSMutableArray *arrayTypes;

// retourne l'unique instance du parser
+ (FilterParser *) instance;

// Méthode récupérant l'ensemble des noms des cercles, clubs et associations depuis le site
- (void)loadFromURL;

// Méthode récupérant l'ensemble des noms des cercles, clubs et associations depuis une sauvegarde locale
- (void)loadFromFile;

// Méthode appelée par les autres pour récupérer les informations nécéssaires
- (void) handle:(TBXMLElement *)listNamesToParse;

@end
