//
//  Folder Filter.m
//  Folder Filter
//
//  Created by Kol. Panic on 01/01/07.
//

#import "Folder Filter.h"
#import <OSAKit/OSAKit.h>

@implementation Folder_Filter

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
	id output = input;
	NSString *path = nil;
	
	if ([input isKindOfClass:[NSArray class]]) {
		if ([input count] < 1) {
			NSArray *objsArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:errOSASystemError], @"Error: nothing passed to Folder Filter", nil];
			NSArray *keysArray = [NSArray arrayWithObjects:OSAScriptErrorNumber, OSAScriptErrorMessage, nil];
			*errorInfo = [NSDictionary dictionaryWithObjects:objsArray forKeys:keysArray];
			return nil;
		}
		
		if ([[[self parameters] objectForKey:@"listHandlingIndex"] intValue] == 0) {
			// find the first folder in the list
			NSEnumerator *e = [(NSArray *)input objectEnumerator];
			NSString *p;
			while (p = [e nextObject]) {
				NSFileWrapper *fw = [[[NSFileWrapper alloc] initWithPath:p] autorelease];
				if ([fw isDirectory] && ![[NSWorkspace sharedWorkspace] isFilePackageAtPath:p]) {
					path = p;
					break;
				}
			}
			if (!path)
				path = [(NSArray *)input objectAtIndex:0];
		} else
			path = [input objectAtIndex:0]; // use the first item in the list
	}
	
	if (path != nil) {
		// if its a plain file or a bundle (and the option is set), use its enclosing directory
		if ( ![[[[NSFileWrapper alloc] initWithPath:path] autorelease] isDirectory] || 
			 ([[NSWorkspace sharedWorkspace] isFilePackageAtPath:path] && ([[[self parameters] objectForKey:@"useBundleIndex"] intValue] == 1)) )
			path = [path stringByDeletingLastPathComponent];
		output = [NSArray arrayWithObject:path];
	}
	
	return output;
}

@end