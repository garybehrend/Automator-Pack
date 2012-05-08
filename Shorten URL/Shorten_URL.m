//
//  Shorten_URL.m
//  Shorten_URL
//
//  Created by Karl Moskowski on 10-06-01.
//  Copyright 2010 Karl Moskowski, All Rights Reserved.
//

#import "Shorten_URL.h"
#import "JSON/JSON.h"
#import "NSString+URIQuery.h"

@implementation Shorten_URL

- (id) runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
    id output = input;
    NSInteger shorteningServiceTag = [[[self parameters] objectForKey:@"shorteningServiceTag"] integerValue];
    NSURL *inputURL = nil;
    if ([input isKindOfClass:[NSString class]])
        inputURL = [NSURL URLWithString:input];
    if ([input isKindOfClass:[NSURL class]])
        inputURL = input;
    if ([[inputURL scheme] isEqualToString:@"http"] || [[inputURL scheme] isEqualToString:@"https"]) {
        NSInteger useCanonicalShortener = [[[self parameters] objectForKey:@"useCanonicalShortener"] boolValue];
        NSString *host = [inputURL host];
        BOOL isYouTube = [host isEqualToString:@"youtube.com"] || [host isEqualToString:@"www.youtube.com"];
        useCanonicalShortener = useCanonicalShortener && (isYouTube);
        if (useCanonicalShortener) {
            if (isYouTube) {
                NSString *v = [[[inputURL query] queryDictionaryUsingEncoding:NSUTF8StringEncoding] objectForKey:@"v"];
                if (v != nil) {
                    NSURL *outputURL = [[NSURL alloc] initWithScheme:[inputURL scheme] host:@"youtu.be" path:[NSString stringWithFormat:@"/%@", v]];
                    output = [outputURL absoluteString];
                } else
                    useCanonicalShortener = NO;
            }
        }
        if (!useCanonicalShortener) {
            switch (shorteningServiceTag) {
                case 1:
                    output = [self shortenWithTinyURL:inputURL];
                    break;
                case 2:
                    output = [self shortenWithIsgd:inputURL];
                    break;
                default:
                    output = [self shortenWithGoogl:inputURL];
                    break;
            }
        }
    }
    return output;
}

- (NSString *) shortenWithIsgd:(NSURL *)inputURL {
    NSString *const baseURL = @"http://is.gd/api.php?longurl=%@";
    NSURL *shorteningURL = [NSURL URLWithString:[NSString stringWithFormat:baseURL, [self encode:inputURL]]];
    NSString *returnedString = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:shorteningURL] encoding:NSUTF8StringEncoding];
    return returnedString;
}

- (NSString *) shortenWithTinyURL:(NSURL *)inputURL {
    NSString *const baseURL = @"http://tinyurl.com/api-create.php?url=%@";
    NSURL *shorteningURL = [NSURL URLWithString:[NSString stringWithFormat:baseURL, [self encode:inputURL]]];
    NSString *returnedString = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:shorteningURL] encoding:NSUTF8StringEncoding];
    return returnedString;
}

- (NSString *) shortenWithGoogl:(NSURL *)inputURL {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.googleapis.com/urlshortener/v1/url"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [[NSString stringWithFormat:@"{\"longUrl\":\"%@\"}", inputURL, nil] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:jsonData];
    NSData *returnedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnedString = [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
    NSDictionary *returnedJson = [returnedString JSONValue];
    if ([returnedJson objectForKey:@"error_message"] == nil) {
        NSString *shortURLString = [[NSURL URLWithString:[returnedJson objectForKey:@"id"]] absoluteString];
        return shortURLString;
    }
    return [inputURL absoluteString];
}

- (NSString *) encode:(NSURL *)url {
    CFStringRef encoded = (CFStringRef)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[url absoluteString], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    CFRelease(encoded);
    return (NSString *)encoded;
}

@end
