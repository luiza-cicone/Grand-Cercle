//
//  news.h
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject {
    // Titre
    NSString *title;
    // Déscription
    NSString *description;
    // Lien
    NSURL *theLink;
    // Date de publication
    NSString *pubDate;
    // Auteur
    NSString *author;
    // Groupe de l'auteur
    NSString *group;
    // Logo de l'association
    NSURL *logo;
}

@property (nonatomic, retain) NSString *title, *description, *pubDate, *author, *group;
@property (nonatomic, retain) NSURL *theLink, *logo;


@end
