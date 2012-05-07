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
		BOOL isAmazon = [host isEqualToString:@"amazon.com"] || [host isEqualToString:@"www.amazon.com"] || [host isEqualToString:@"amazon.ca"] || [host isEqualToString:@"www.amazon.ca"];
		useCanonicalShortener = useCanonicalShortener && (isYouTube || isAmazon);
		if (useCanonicalShortener) {
			if (isYouTube) {
				NSString *v = [[[inputURL query] queryDictionaryUsingEncoding:NSUTF8StringEncoding] objectForKey:@"v"];
				if (v != nil) {
					NSURL *outputURL = [[NSURL alloc] initWithScheme:[inputURL scheme] host:@"youtu.be" path:[NSString stringWithFormat:@"/%@", v]];
					output = [outputURL absoluteString];
				} else
					useCanonicalShortener = NO;
			} else if (isAmazon)
				output = [self shortenWithBitly:inputURL];
		}
		if (!useCanonicalShortener) {
			switch (shorteningServiceTag) {
				case 0:
					output = [self shortenWithBitly:inputURL];
					break;
				case 1:
					output = [self shortenWithGoogl:inputURL];
					break;
				case 2:
					output = [self shortenWithIsgd:inputURL];
					break;
				default:
					output = [self shortenWithTinyURL:inputURL];
					break;
			}
		}
	}
	return output;
}

// bit.ly and goo.gl now require API keys, so their options are now hidden in the UI

- (NSString *) shortenWithBitly:(NSURL *)inputURL {
	NSString *const baseURL = @"http://bit.ly/api?url=%@";
	NSURL *shorteningURL = [NSURL URLWithString:[NSString stringWithFormat:baseURL, [self encode:inputURL]]];
	NSString *returnedString = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:shorteningURL] encoding:NSUTF8StringEncoding];
	return returnedString;
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
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://goo.gl/api/url"]];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[[NSString stringWithFormat:@"user=toolbar@google.com&url=%@", [self encode:inputURL]] dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *returnedData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	NSString *returnedString = [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
	NSDictionary *returnedJson = [returnedString JSONValue];
	if ([returnedJson objectForKey:@"error_message"] == nil) {
		NSString *shortURLString = [[NSURL URLWithString:[returnedJson objectForKey:@"short_url"]] absoluteString];
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
