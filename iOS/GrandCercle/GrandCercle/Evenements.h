//
//  Evenements.h
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface Evenements : News {
    // Jour
    NSString *day;
    // Date
    NSString *date;
    // Heure de début
    NSString *time;
    // Image petite
    NSURL *imageSmall;
    //Type
    NSString *type;
    // Image
    NSURL *image;
    // Lieu
    NSString *place;
    // Prix avec cva
    NSString *priceCva;
    // Prix sans cva
    NSString *priceNoCva;
}

@property (nonatomic, retain) NSString *day, *date, *time, *type, *place, *priceCva, *priceNoCva;
@property (nonatomic, retain) NSURL *imageSmall, *image;

@end
