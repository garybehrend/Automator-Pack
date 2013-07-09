//
//  Folder_Filter.h
//  Folder Filter
//
//  Created by Karl Moskowski on 7/9/2013.
//  Copyright (c) 2013 Karl Moskowski. All rights reserved.
//

#import <Automator/AMBundleAction.h>

@interface Folder_Filter : AMBundleAction

- (id) runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
