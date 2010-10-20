//
//  Shorten URL.h
//  Shorten URL
//
//  Created by Karl Moskowski on 10-06-01.
//  Copyright 2010 Karl Moskowski, All Rights Reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface Shorten_URL : AMBundleAction

- (id) runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

- (NSString *) shortenWithBitly:(NSURL *)inputURL;
- (NSString *) shortenWithIsgd:(NSURL *)inputURL;
- (NSString *) shortenWithTinyURL:(NSURL *)inputURL;
- (NSString *) shortenWithGoogl:(NSURL *)inputURL;

- (NSString *) encode:(NSURL *)url;

@end
