//
//  EvenementsParser.h
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "TBXML+HTTP.h"
#import "TBXML.h"
#import "NSString+HTML.h"

@interface EventsParser : NSObject {

    TBXML *tbxml;
    NSManagedObjectContext *managedObjectContext;

}

+ (EventsParser *) instance;

- (void)loadFromURL;
- (void)loadFromFile;

- (void) handle:(TBXMLElement *)eventsToParse;

@end
