//
//  Open Terminal Here.m
//  Open Terminal Here
//
//  Created by Karl Moskowski on 01/01/07.
//  Copyright 2007 tacow. All rights reserved.
//

#import "Open Terminal Here.h"

@implementation Open_Terminal_Here

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
	NSString *path = nil;
	
	if ([input isKindOfClass:[NSArray class]])
		path = [input objectAtIndex:0];
	else
		path = input;
	
	if (path != nil) {
		if ([[[[NSFileWrapper alloc] initWithPath:path] autorelease] isDirectory]) {
			NSString *script = [NSString stringWithFormat:
				@"tell application \"Terminal\" \n\
					activate \n\
					try \n\
					do script \"cd \\\"%@\\\"\" in window 1 \n\
					on error \n\
					do script \"cd \\\"%@\\\"\" \n\
					end try \n\
					end tell",
				path, path];
			[[[NSAppleScript alloc] initWithSource:script] executeAndReturnError:nil];
		}
	}
	
	return input;
}

@end