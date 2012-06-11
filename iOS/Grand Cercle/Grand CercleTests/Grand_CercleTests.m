//
//  Grand_CercleTests.m
//  Grand CercleTests
//
//  Created by Luiza Cicone on 28/5/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "Grand_CercleTests.h"
#import "EventsParser.h"

@implementation Grand_CercleTests

- (void)setUp
{
    [super setUp];
    
    delegate = [[UIApplication sharedApplication] delegate];
    arrayWithEvents = [[NSMutableArray alloc] initWithCapacity:1];
    arrayWithEvents2 = [[NSMutableArray alloc] initWithCapacity:1];

    NSString *xmlString = @"\
    <nodes>\
    <node>\
    <title>Evenement</title>\
    <day>Lundi</day>\
    <date>16 juin 2012</date>\
    <time>13h00</time>\
    <thumbnail>\
http://grandcercle.org/sites/default/files/styles/mobile_square/public/wed_cpp_logo.jpg\
    </thumbnail>\
    <type>Autre</type>\
    <author>Ensimag</author>\
    <description>Une description</description>\
    <image>\
http://grandcercle.org/sites/default/files/styles/mobile_small/public/wed_cpp_logo.jpg\
    </image>\
    <lieu>Ici</lieu>\
    <pubDate>1338582490</pubDate>\
    <group>Ensimag</group>\
    <logo>\
http://grandcercle.org/sites/default/files/styles/mobile_small/public/cpp.png\
    </logo>\
    <link>http://grandcercle.org/evenements/wed-cpp-2012</link>\
    <eventDate>16-06-2012</eventDate>\
    </node>\
    </nodes>";    
    [[EventsParser instance] loadEventsFromString:xmlString toArray:arrayWithEvents];
        
    NSString *xmlString2 = @"\
    <nodes>\
    <node>\
    <title></title>\
    <day></day>\
    <date></date>\
    <time></time>\
    <thumbnail>\
    </thumbnail>\
    <type></type>\
    <author></author>\
    <description></description>\
    <image>\
    </image>\
    <lieu></lieu>\
    <pubDate></pubDate>\
    <group></group>\
    <logo>\
    </logo>\
    <link></link>\
    <eventDate></eventDate>\
    </node>\
    </nodes>";
    [[EventsParser instance] loadEventsFromString:xmlString2 toArray:arrayWithEvents2];
}

- (void)tearDown
{
    // Tear-down code here.
    [arrayWithEvents release];
    [super tearDown];
}

- (void)testEventParser
{
    STAssertEqualObjects([(Events *)[arrayWithEvents objectAtIndex:0] title], @"Evenement", @"Parse Error : Incorrect title !");
    STAssertEqualObjects([(Events *)[arrayWithEvents objectAtIndex:0] place], @"Ici", @"Parse Error : Incorrect title !");
    
    NSDateFormatter* firstDateFormatter = [[NSDateFormatter alloc] init];
    [firstDateFormatter setDateFormat:@"dd-MM-yy hh:mm:ss zzz"];
    STAssertEqualObjects([(Events *)[arrayWithEvents objectAtIndex:0] eventDate], [firstDateFormatter dateFromString:@"16-06-2012 00:00:00 +0000"], @"Parse Error : Incorrect title !");
    [firstDateFormatter release];
    
    STAssertEqualObjects([(Events *)[arrayWithEvents objectAtIndex:0] day], @"Lundi", @"Parse Error : Incorrect title !");
    STAssertEqualObjects([(Events *)[arrayWithEvents objectAtIndex:0] date], @"16 juin 2012", @"Parse Error : Incorrect title !");
    STAssertEqualObjects([(Events *)[arrayWithEvents objectAtIndex:0] group], @"Ensimag", @"Parse Error : Incorrect title !");
}


- (void)testEventParserNullEvent
{
    NSLog(@"%@", arrayWithEvents);
    STAssertEqualObjects([(Events *)[arrayWithEvents2 objectAtIndex:0] title], @"", @"Parse Error : Incorrect title !");
    STAssertEqualObjects([(Events *)[arrayWithEvents2 objectAtIndex:0] place], @"", @"Parse Error : Incorrect title !");
    STAssertEqualObjects([(Events *)[arrayWithEvents2 objectAtIndex:0] day], @"", @"Parse Error : Incorrect title !");
    STAssertEqualObjects([(Events *)[arrayWithEvents2 objectAtIndex:0] date], @"", @"Parse Error : Incorrect title !");
    STAssertEqualObjects([(Events *)[arrayWithEvents2 objectAtIndex:0] group], @"", @"Parse Error : Incorrect title !");
}

@end
