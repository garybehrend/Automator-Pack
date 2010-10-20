//
//  Folder Filter.h
//  Folder Filter
//
//  Created by Kol. Panic on 01/01/07.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface Folder_Filter : AMBundleAction  {
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end