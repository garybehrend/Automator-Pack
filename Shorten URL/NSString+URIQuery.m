//
//  NSString+URIQuery.m
//  Shorten_URL
//
//  Created by Karl Moskowski on 10-08-10.
//  Copyright 2010 Karl Moskowski. All rights reserved.
//

#import "NSString+URIQuery.h"

@implementation NSString (URIQuery)

// Adapted from Jerry Krinock's category at http://www.cocoadev.com/index.pl?URLParsing

- (NSDictionary *) queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
	NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
	NSScanner *scanner = [[[NSScanner alloc] initWithString:self] autorelease];
	while (![scanner isAtEnd]) {
		NSString *pairString;
		[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
		[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
		NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
		if ([kvPair count] == 2) {
			NSString *key = [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding];
			NSString *value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding];
			[pairs setObject:value forKey:key];
		}
	}
	return [NSDictionary dictionaryWithDictionary:pairs];
}

@end
