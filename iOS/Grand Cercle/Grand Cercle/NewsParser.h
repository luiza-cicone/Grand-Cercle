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

#import "News.h"

@interface NewsParser : NSObject {
    
    TBXML *tbxml;
    NSManagedObjectContext *managedObjectContext;
}

+ (NewsParser *) instance;

// Méthode récupérant l'ensemble des news depuis le site
- (void) loadNewsFromURL;

// Méthode appelée par les autres pour récupérer les informations nécéssaires
- (void) handle:(TBXMLElement *)newsToParse;

@end