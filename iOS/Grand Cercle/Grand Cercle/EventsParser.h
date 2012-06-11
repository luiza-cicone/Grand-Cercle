//
//  EvenementsParser.h
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Events.h"
#import "TBXML+HTTP.h"
#import "TBXML.h"
#import "NSString+HTML.h"

@interface EventsParser : NSObject {
    // Parser
    TBXML *tbxml;
    // Tableau contenant les événements, l'un les futurs et l'autre les anciens
	NSMutableArray *arrayEvents, *arrayOldEvents;
}

@property (nonatomic, retain) NSMutableArray *arrayEvents, *arrayOldEvents;

// Patron singleton, retourne l'unique instance du parser d'événements
+ (EventsParser *) instance;
// Méthode récupérant l'ensemble des événements depuis le site
- (void)loadEventsFromURL;
// Méthode récupérant l'ensemble des événements depuis une sauvegarde locale
- (void)loadEventsFromFile;
// Méthode appelée par les autres pour récupérer les informations nécéssaires
- (void) handleEvents:(TBXMLElement *)eventsToParse toArray:(NSMutableArray *) array withFilter:(BOOL) filter;
- (void) loadEventsFromString: (NSString *) xmlString toArray: (NSMutableArray *) array;
@end
