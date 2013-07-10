//
//  Shorten_URL.m
//  Shorten URL
//
//  Created by Karl Moskowski on 7/9/2013.
//  Copyright (c) 2013 Karl Moskowski. All rights reserved.
//

#import "Shorten_URL.h"
#import "NSString+URIQuery.h"

@implementation Shorten_URL

- (id) runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
	id output = input;
	NSInteger shorteningServiceTag = [[[self parameters] objectForKey:@"shorteningServiceTag"] integerValue];
	NSURL *inputURL = nil;
	if ([input isKindOfClass:[NSArray class]])
		input = input[0];
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

- (NSString *) shortenWithGoogl:(NSURL *)inputURL {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.googleapis.com/urlshortener/v1/url"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:[inputURL absoluteString] forKey:@"longUrl"];
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
	[request setHTTPBody:jsonData];
	NSData *returnedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSDictionary *returnedJson =  [NSJSONSerialization JSONObjectWithData:returnedData options:NSJSONReadingMutableContainers error:nil];
	if ([returnedJson objectForKey:@"error_message"] == nil) {
		NSString *shortURLString = [[NSURL URLWithString:[returnedJson objectForKey:@"id"]] absoluteString];
		return shortURLString;
	}
	return [inputURL absoluteString];
}

- (NSString *) shortenWithTinyURL:(NSURL *)inputURL {
	NSString *const baseURL = @"http://tinyurl.com/api-create.php?url=%@";
	NSURL *shorteningURL = [NSURL URLWithString:[NSString stringWithFormat:baseURL, [inputURL absoluteString]]];
	NSString *returnedString = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:shorteningURL] encoding:NSUTF8StringEncoding];
	return returnedString;
}

- (NSString *) shortenWithIsgd:(NSURL *)inputURL {
	NSString *const baseURL = @"http://is.gd/api.php?longurl=%@";
	NSURL *shorteningURL = [NSURL URLWithString:[NSString stringWithFormat:baseURL, [inputURL absoluteString]]];
	NSString *returnedString = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:shorteningURL] encoding:NSUTF8StringEncoding];
	return returnedString;
}

@end
