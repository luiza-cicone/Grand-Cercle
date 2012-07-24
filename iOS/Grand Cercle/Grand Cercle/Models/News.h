//
//  News.h
//  TapkuLibrary
//
//  Created by Luiza Cicone on 21/7/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Association;

@interface News : NSManagedObject

@property (nonatomic, retain) NSNumber * idNews;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * pubDate;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) Association *author;

@end
