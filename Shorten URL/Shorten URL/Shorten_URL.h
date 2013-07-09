//
//  Shorten_URL.h
//  Shorten URL
//
//  Created by Karl Moskowski on 7/9/2013.
//  Copyright (c) 2013 Karl Moskowski. All rights reserved.
//

#import <Automator/AMBundleAction.h>

@interface Shorten_URL : AMBundleAction

- (id) runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

- (NSString *) shortenWithGoogl:(NSURL *)inputURL;
- (NSString *) shortenWithTinyURL:(NSURL *)inputURL;
- (NSString *) shortenWithIsgd:(NSURL *)inputURL;

@end
