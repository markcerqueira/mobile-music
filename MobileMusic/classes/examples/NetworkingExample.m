//
//  NetworkingExample.m
//  MobileMusic
//
//  Created by Mark on 7/2/12.
//

#import "NetworkingExample.h"
#import "MBRequest.h"

@implementation NetworkingExample

+ (void)returnLatestTopTweets:(NSInteger)tweetsToFetch;
{
    // insert the number of tweets we want to fetch into the string
    NSString *twitterURL = [NSString stringWithFormat:@"https://api.twitter.com/1/favorites.json?count=%d&screen_name=toptweets", tweetsToFetch];
    
    // create the HTTP request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:twitterURL]];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    MBJSONRequest *jsonRequest = [[[MBJSONRequest alloc] init] autorelease];
    
    // execute the request, the block below will execute asynchronously when the network layer returns data!
    [jsonRequest performJSONRequest:urlRequest completionHandler:^(id responseJSON, NSError *error) {
        if (error != nil)
        {
            NSLog(@"[NetworkingExample] Error requesting top tweets with error: %@", error);
        }
        else
        {
            // make sure we are looking at an array before trying to parse it
            if ( ![responseJSON isKindOfClass:[NSArray class]] )
            {
                NSLog(@"[NetworkingExample] expected an array of tweets and did not get it");
                return;
            }
            
            NSArray *tweets = (NSArray *)responseJSON;
            
            for (NSDictionary *tweet in tweets)
            {
                NSString *text = [tweet objectForKey:@"text"];
                NSLog(@"[NetworkingExample] a top tweet is: %@", text);
            }
        }
    }];
}

@end
