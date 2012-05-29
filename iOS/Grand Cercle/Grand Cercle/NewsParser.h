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
#import "News.h"

@interface NewsParser : NSObject {

    // Parser
    TBXML *tbxml;
    // Ensemble des News
	NSMutableArray *arrayNews;
}

@property(nonatomic, retain) NSMutableArray *arrayNews;

// Méthode récupérant l'ensemble des news
+ (NewsParser *) instance;
- (void) loadNews;
- (void) treatementNews:(TBXMLElement *)element;

@end
