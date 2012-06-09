//
//  Items.h
//  Grand Cercle
//
//  Created by Jérémy Krein on 29/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Items : NSObject {
    // Titre
    NSString *title;
    // Déscription
    NSString *description;
    // Lien
    NSString *theLink;
    // Logo de l'association ou visuel du bon plan
    NSString *logo;
}

@property (nonatomic, retain) NSString *title, *description, *theLink, *logo;

@end
