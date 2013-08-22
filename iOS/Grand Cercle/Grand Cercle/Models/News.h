//
//  News.h
//  Grand Cercle
//
//  Created by Luiza Cicone on 19/8/13.
//  Copyright (c) 2013 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Association;

@interface News : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * idNews;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * pubDate;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * thumbnail2x;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * image2x;
@property (nonatomic, retain) Association *author;

@end
