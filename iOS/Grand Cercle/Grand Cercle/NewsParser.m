//
//  NewsParser.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "NewsParser.h"

@implementation NewsParser
static NewsParser *instanceNews = nil;

@synthesize arrayNews;

// singleton
+ (NewsParser *) instance {
    if (instanceNews == nil) {
        instanceNews = [[self alloc] init];
    }
    return instanceNews;
}

- (void) treatementNews:(TBXMLElement *)newsAParser {
	do {

        // Définition de la news à récupérer
        News *aNews = [[News alloc] init];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:newsAParser];
        aNews.title = [[TBXML textForElement:title]  stringByConvertingHTMLToPlainText];
        
        // Récupération de la description
        TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:newsAParser];
        aNews.description = [[TBXML textForElement:description] stringByDecodingHTMLEntities];
        
        // Récupération du lien
        TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:newsAParser];
        aNews.theLink = [[TBXML textForElement:link] stringByConvertingHTMLToPlainText];
        
        // Récupération de la date de publication
        TBXMLElement *pubDate = [TBXML childElementNamed:@"pubDate" parentElement:newsAParser];
        aNews.pubDate = [[TBXML textForElement:pubDate] stringByConvertingHTMLToPlainText];
        
        // Récupération de l'auteur
        TBXMLElement *author = [TBXML childElementNamed:@"author" parentElement:newsAParser];
        aNews.author = [[TBXML textForElement:author]  stringByConvertingHTMLToPlainText];
        
        // Récupération du groupe
        TBXMLElement *group = [TBXML childElementNamed:@"group" parentElement:newsAParser];
        aNews.group = [[TBXML textForElement:group]  stringByConvertingHTMLToPlainText];
        
        // Récupération du logo
        TBXMLElement *logo = [TBXML childElementNamed:@"logo" parentElement:newsAParser];
        aNews.logo = [[TBXML textForElement:logo]  stringByConvertingHTMLToPlainText];
        
        // Ajout de la news au tableau
        [arrayNews addObject:aNews];
        [aNews release];
        
	} while ((newsAParser = newsAParser->nextSibling));
}

- (void)loadNews { 
    
    // Initialisation du tableau contenant les News
    arrayNews = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Create a success block to be called when the async request completes
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        // If TBXML found a root node, process element and iterate all children
        if (tbxmlDocument.rootXMLElement)
            [self treatementNews:tbxmlDocument.rootXMLElement->firstChild];
    };

    
    // Create a failure block that gets called if something goes wrong
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    };
    
    // Initialize TBXML with the URL of an XML doc. TBXML asynchronously loads and parses the file.
    tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/news/data.xml"] 
                               success:successBlock 
                               failure:failureBlock];

}

@end
