//
//  NewsParser.h
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML+HTTP.h"
#import "TBXML.h"
#import "NSString+HTML.h"

#import "Newss.h"

@interface NewsParser : NSObject {
    // Parser
    TBXML *tbxml;
    // Tableau contenant les News
	NSMutableArray *arrayNews;
}

@property(nonatomic, retain) NSMutableArray *arrayNews;

// Patron singleton, unique instance du parser de news
+ (NewsParser *) instance;

// Méthode récupérant l'ensemble des news depuis le site
- (void) loadNewsFromURL;
// Méthode récupérant l'ensemble des news depuis une sauvegarde locale
- (void) loadNewsFromFile;
// Méthode appelée par les autres pour récupérer les informations nécéssaires
- (void) handleNews:(TBXMLElement *)newsToParse;

@end