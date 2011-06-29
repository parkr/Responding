//
//  RespondingAppDelegate.m
//  Responding
//
//  Created by Parker Moore on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RespondingAppDelegate.h"

@implementation RespondingAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	NSSize minSize;
	minSize.width = 900;
	minSize.height = 563;
	[window setMinSize:minSize];
}

@end
