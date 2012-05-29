//
//  news.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "News.h"

@implementation News
@synthesize title, description, pubDate,author, theLink, group, logo;
    
    - (id) init {
        self = [super init];
        return self;
    }

@end
