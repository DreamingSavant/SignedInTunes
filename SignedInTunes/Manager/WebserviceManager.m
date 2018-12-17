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


- (void)getAlbums:(void (^)(NSDictionary *))completion {
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://itunes.apple.com/us/rss/topalbums/limit=50/json"];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                                 completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          // deserialize the data
        dispatch_async(dispatch_get_main_queue(), ^{
          
          NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
          
          completion(jsonDict);
    
        });
    }];
    
    [dataTask resume];
    
}

@end
