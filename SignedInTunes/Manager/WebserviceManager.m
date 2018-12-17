//
//  WebserviceManager.m
//  SignedInTunes
//
//  Created by Kevin Yu on 12/17/18.
//  Copyright © 2018 Kevin Yu. All rights reserved.
//

#import "WebserviceManager.h"
#import "CoreDataManager.h"

@implementation WebserviceManager

+ (WebserviceManager *)sharedInstance {
    static WebserviceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


- (void)getAlbums:(void (^)(NSArray<Album *> *))completion {
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://itunes.apple.com/us/rss/topalbums/limit=50/json"];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                                 completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          // deserialize the data
        dispatch_async(dispatch_get_main_queue(), ^{
          
          NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
          
          NSDictionary *feedDict = jsonDict[@"feed"];
          if (feedDict == nil) {
              return;
          }
          NSArray *entries = feedDict[@"entry"];
          if (entries == nil && entries.count == 0) {
              return;
          }
          
          NSMutableArray *myAlbumsArray = [[NSMutableArray alloc] init];
          
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
          dateFormatter.dateFormat = @"yyyy-mm-ddThh:mm:ss.nnnnnn+|-hh:mm";
          
          NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
          [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
          
          // create albums in our context
          for (NSDictionary *entry in entries) {
              // create object populate object using the manager
              
              NSString *artistName = entry[@"im:artist"][@"label"];
              
              NSString *albumName = entry[@"im:name"][@"label"];
              
              NSString *releaseString = entry[@"im:releaseDate"][@"label"]; // 2018-12-14T00:00:00-07:00
              NSDate *dateOfRelease = [dateFormatter dateFromString:releaseString];
              
              NSString *imageURLString = entry[@"im:image"][0][@"label"];
              NSURL *imageLink = [[NSURL alloc] initWithString:imageURLString];
              
              NSString *genre = entry[@"category"][@"attributes"][@"term"];
              
              NSString *priceString = entry[@"im:price"][@"label"]; // "$12.21"
              NSNumber *price = [priceFormatter numberFromString:priceString];
              
              Album *album = [[CoreDataManager sharedInstance] createAlbumWith:artistName
                                                                     albumName:albumName
                                                                   releaseDate:dateOfRelease
                                                                      imageURL:imageLink
                                                                         genre:genre
                                                                         price:price];
              // add object to albums
              [myAlbumsArray addObject:album];
          }
          
          // call completion with albums
          completion([myAlbumsArray copy]);
    
        });
    }];
    
    [dataTask resume];
    
}

@end
