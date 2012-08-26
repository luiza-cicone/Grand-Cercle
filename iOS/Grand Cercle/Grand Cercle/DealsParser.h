//
//  BonsPlansParser.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 30/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deal.h"
#import "TBXML+HTTP.h"
#import "NSString+HTML.h"

#import "TBXML.h"

@interface DealsParser : NSObject {
    
    TBXML *tbxml;
    NSManagedObjectContext *managedObjectContext;
}

+ (DealsParser *) instance;

// Méthode récupérant l'ensemble des bons plans depuis le site
- (void) loadFromURL;

// Méthode appelée par les autres pour récupérer les informations nécéssaires
- (void) handle:(TBXMLElement *)dealsToParse;

@end