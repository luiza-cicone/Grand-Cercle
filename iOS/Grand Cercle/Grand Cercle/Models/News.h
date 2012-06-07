//
//  News.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 6/6/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Association;

@interface News : NSManagedObject

@property (nonatomic, retain) NSString * pubDate;
@property (nonatomic, retain) Association *author;

@end
