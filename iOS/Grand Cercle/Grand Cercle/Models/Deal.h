//
//  Deal.h
//  TapkuLibrary
//
//  Created by Luiza Cicone on 21/7/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Deal : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * image;

@end
