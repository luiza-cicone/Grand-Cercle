//
//  news.h
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Items.h"

@interface NewsOld : Items {
    // Date de publication
    NSString *pubDate;
    // Auteur
    NSString *author;
    // Groupe de l'auteur
    NSString *group;
}

@property (nonatomic, retain) NSString *pubDate, *author, *group;

@end
