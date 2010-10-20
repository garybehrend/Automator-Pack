//
//  Open Terminal Here.h
//  Open Terminal Here
//
//  Created by Karl Moskowski on 01/01/07.
//  Copyright 2007 tacow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface Open_Terminal_Here : AMBundleAction  {
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end