//
//  Evenements.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "Evenements.h"

@implementation Evenements
@synthesize day, date, time, type, place, priceCva, priceNoCva, image, imageSmall, pubDate, group, author;

- (id) init {
    self = [super init];
    return self;
}

@end
