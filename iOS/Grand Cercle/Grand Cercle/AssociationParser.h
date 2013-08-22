//
//  AssociationParser.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 23/7/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TBXML+HTTP.h"
#import "TBXML.h"
#import "NSString+HTML.h"

@interface AssociationParser : NSObject {
    TBXML *tbxml;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

// L'instance du parser
+ (AssociationParser *) instance;

// Méthode récupérant l'ensemble des news depuis l'URL du site
- (void) loadFromURL;
- (void)loadFromFile;

// Méthode qui transforme un node de l'xml en objet
- (void) handle:(TBXMLElement *)objectToParse ofType:(int)type;

@end