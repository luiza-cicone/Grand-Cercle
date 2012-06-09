//
//  Evenements.h
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Items.h"

@interface Events : Items {
    // Date de publication
    NSString *pubDate;
    // Auteur
    NSString *author;
    // Groupe de l'auteur
    NSString *group;
    // Jour
    NSString *day;
    // Date
    NSString *date;
    // Heure de début
    NSString *time;
    // Image de petite taille
    NSString *imageSmall;
    //Type
    NSString *type;
    // Image
    NSString *image;
    // Lieu
    NSString *place;
    // Prix avec cva
    NSString *priceCva;
    // Prix sans cva
    NSString *priceNoCva;
    // Date event
    NSDate *eventDate;
}

@property (nonatomic, retain) NSString *day, *date, *time, *type, *place, *priceCva, *priceNoCva, *pubDate, *author, *group, *imageSmall, *image;
@property (nonatomic, assign) NSDate *eventDate;

@end