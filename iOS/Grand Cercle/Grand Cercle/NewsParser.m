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
@synthesize managedObjectContext;

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
        NSFetchRequest *requestNews = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *newsEntity = [NSEntityDescription entityForName:@"News" inManagedObjectContext:managedObjectContext];
        [requestNews setEntity:newsEntity];
        
        TBXMLElement *idNews = [TBXML childElementNamed:@"id" parentElement:newsToParse];
        NSPredicate *newsIdPredicate = [NSPredicate predicateWithFormat:@"idNews = %@", [TBXML textForElement:idNews]];
        [requestNews setPredicate:newsIdPredicate];        

        NSError *error = nil;
        
        NSArray *news = [managedObjectContext executeFetchRequest:requestNews error:&error];
        News *aNews;
        if (news != nil && error == nil) {
            if([news count] != 0)
                aNews = [news objectAtIndex:0];
            else
                // Initialisation de la news à récupérer
                aNews = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:managedObjectContext];
        }
        else {
            NSLog(@"Error in NewsParser : handle: newsToParse ");
            continue;
        }
        
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
        if (array != nil && array.count > 0 && error == nil) {
            aNews.author =  [array objectAtIndex:0];
        }
        else {
            aNews.author = -1;
        }
        [request release];
        
        // Récupération de l'image
        TBXMLElement *image = [TBXML childElementNamed:@"image" parentElement:newsToParse];
        aNews.image = [[TBXML textForElement:image]  stringByConvertingHTMLToPlainText];
        TBXMLElement *image2x = [TBXML childElementNamed:@"image2x" parentElement:newsToParse];
        aNews.image2x = [[TBXML textForElement:image2x]  stringByConvertingHTMLToPlainText];
        
        TBXMLElement *imageSmall = [TBXML childElementNamed:@"thumb" parentElement:newsToParse];
        aNews.thumbnail = [[TBXML textForElement:imageSmall] stringByConvertingHTMLToPlainText];
        TBXMLElement *imageSmall2x = [TBXML childElementNamed:@"thumb2x" parentElement:newsToParse];
        aNews.thumbnail2x = [[TBXML textForElement:imageSmall2x] stringByConvertingHTMLToPlainText];

        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", [error localizedDescription]);
        }
	} while ((newsToParse = newsToParse->nextSibling));
}

- (void)loadFromURL { 
    
    if (managedObjectContext == nil) { 
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
    
    NSLog(@"NewsParser.loadFromURL : try to update news");
    
    /*  send a request for file modification date  */
    NSURLRequest *modReq = [NSURLRequest requestWithURL:[NSURL URLWithString:kNewsURL]
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
    NSURLResponse* response;
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:modReq returningResponse:&response error:&error];
    
    NSString * last_modified = [NSString stringWithFormat:@"%@",
                                [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Last-Modified"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![last_modified isEqualToString:[defaults stringForKey:@"news-last-modified"]]) {
        [defaults setObject:last_modified forKey:@"news-last-modified"];
        
        NSLog(@"NewsParser.loadFromURL : updating news");
        
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
        tbxml = [[TBXML alloc] initWithURL:[NSURL URLWithString:kNewsURL] 
                                   success:successBlock 
                                   failure:failureBlock];
        
        NSLog(@"NewsParser.loadFromURL : finished updating news");

    }
}

-(void) loadFromFile {
    NSLog(@"NewsParser.loadFromFile");

    if (managedObjectContext == nil) {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // Initialisation des fichiers TBXML avec le chemin de la sauvegarde interne
    NSError *error = nil;
    
    tbxml = [[TBXML alloc] initWithXMLFile:@"news.xml" error:&error];
    
    if (error) {
        // Si l'initialisation s'est mal passée, on affiche l'erreur
        NSLog(@"Error! %@ %@", [error localizedDescription], [error userInfo]);
    } else {
        // Si aucune erreur n'est levée, on parse la sauvegarde interne
        if (tbxml.rootXMLElement)
            [self handle:[TBXML childElementNamed:@"node" parentElement:tbxml.rootXMLElement]];
    }
    [tbxml release];
    NSLog(@"NewsParser.loadFromFile : finished loading news");

}

@end