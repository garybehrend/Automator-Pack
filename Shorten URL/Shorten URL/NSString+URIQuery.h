//
//  NSString+URIQuery.h
//  Shorten_URL
//
//  Created by Karl Moskowski on 10-08-10.
//  Copyright 2010 Karl Moskowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URIQuery)

- (NSDictionary *) queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

@end
