//
//  NewsParser.m
//  GrandCercle
//
//  Created by Jérémy Krein on 28/05/12.
//  Copyright (c) 2012 Ensimag. All rights reserved.
//

#import "NewsParser.h"
#import "AppDelegate.h"
#import "Association.h"

@implementation NewsParser

static NewsParser *instanceNews = nil;

+ (NewsParser *) instance {
    if (instanceNews == nil) {
        instanceNews = [[self alloc] init];
    }
    return instanceNews;
}

- (void) handle:(TBXMLElement *)newsToParse {

    // Tant qu'il y a une news à traiter
	do {
        // Test if the news is already in the DB
        NSFetchRequest *requestNews = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *newsEntity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext];
        [requestNews setEntity:newsEntity];
        
        TBXMLElement *idNews = [TBXML childElementNamed:@"id" parentElement:newsToParse];
        NSPredicate *newsIdPredicate = [NSPredicate predicateWithFormat:@"idNews = %@", [TBXML textForElement:idNews]];
        [requestNews setPredicate:newsIdPredicate];        

        NSError *error = nil;
        
        NSArray *news = [managedObjectContext executeFetchRequest:requestNews error:&error];
        if (news != nil && error == nil) {
            if([news count] != 0)
                continue;
        }
        
        // Initialisation de la news à récupérer
        News *aNews = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:managedObjectContext];
        
        aNews.idNews = [NSNumber numberWithInt:[[TBXML textForElement:idNews] intValue]];
        
        // Récupération du titre
        TBXMLElement *title = [TBXML childElementNamed:@"title" parentElement:newsToParse];
        aNews.title = [[TBXML textForElement:title] stringByConvertingHTMLToPlainText];
        
        // Récupération de la description
        TBXMLElement *content = [TBXML childElementNamed:@"description" parentElement:newsToParse];
        aNews.content = [[TBXML textForElement:content] stringByDecodingHTMLEntities];
        
        // Récupération de la date de publication
        TBXMLElement *pubDate = [TBXML childElementNamed:@"pubDate" parentElement:newsToParse];
        aNews.pubDate = [[TBXML textForElement:pubDate] stringByConvertingHTMLToPlainText];
        
        // Récupération de l'assos auteur
        TBXMLElement *author = [TBXML childElementNamed:@"author" parentElement:newsToParse];
        
        NSEntityDescription *assosEntity = [NSEntityDescription entityForName:@"Association" inManagedObjectContext:managedObjectContext]; 
        NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
        NSPredicate *ofIdPredicate = [NSPredicate predicateWithFormat:@"idAssos = %@", [TBXML textForElement:author]];
        [request setEntity:assosEntity];
        [request setPredicate:ofIdPredicate];        
        
        error = nil;
        
        NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
        if (array != nil && error == nil) {
            aNews.author =  [array objectAtIndex:0];
        }
        else {
            // Deal with error.
        }
        [request release];
        // Récupération de l'image
        TBXMLElement *image = [TBXML childElementNamed:@"image" parentElement:newsToParse];
        aNews.image = [[TBXML textForElement:image]  stringByConvertingHTMLToPlainText];
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
	} while ((newsToParse = newsToParse->nextSibling));
}

- (void)loadNewsFromURL { 
    
    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    /*  send a request for file modification date  */
    NSURLRequest *modReq = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/xml/news.xml"]
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
    NSURLResponse* response;
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:modReq returningResponse:&response error:&error];
    
    NSString * last_modified = [NSString stringWithFormat:@"%@",
                                [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Last-Modified"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (! [last_modified isEqualToString:[defaults stringForKey:@"news-last-modified"]]) {
        [defaults setObject:last_modified forKey:@"news-last-modified"];
        
        NSFetchRequest * allNews = [[NSFetchRequest alloc] init];
        [allNews setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext]];
        [allNews setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * news
        = [managedObjectContext executeFetchRequest:allNews error:&error];
        [allNews release];
        //error handling goes here
        for (News *aNews in news) {
            [managedObjectContext deleteObject:aNews];
        }
        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
        
        // Si le lien du fichier xml est correct, ce block est appelé
        TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
            if (tbxmlDocument.rootXMLElement)
                [self handle:tbxmlDocument.rootXMLElement->firstChild];
        };
        
        // Si le lien du fichier xml est incorrect, ce block est appelé
        TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
            NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
        };
        
        
        
        // Initialisation d'un objet TBXML avec le lien du fichier xml à parser
        tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:@"http://www.grandcercle.org/xml/news.xml"] 
                                   success:successBlock 
                                   failure:failureBlock];
    }
}

@end