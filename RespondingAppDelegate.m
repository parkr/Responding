//
//  RespondingAppDelegate.m
//  Responding
//
//  Created by Parker Moore on 6/28/11.
//  Copyright 2011 Parker Moore. All rights reserved.
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

    // ensure the Application Support directory exists
    [self findOrCreateApplicationSupportDirectory];
}

- (BOOL)findOrCreateApplicationSupportDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(
        NSApplicationSupportDirectory,
        NSUserDomainMask,
        YES);
    if ([paths count] == 0) {
        NSLog(@"Your application support directory has not been found. Weird.");
        return NO;
    }

    NSString *appSupportDir = [paths objectAtIndex:0];
    appSupportDir = [appSupportDir stringByAppendingPathComponent:@"Responding"];
    NSLog(@"appSupportDir = %@", appSupportDir);

    BOOL exists;
    BOOL isDirectory;
    exists = [[NSFileManager defaultManager]
              fileExistsAtPath:appSupportDir
              isDirectory:&isDirectory];

    if (exists) {
        NSLog(@"Your application support dir already exists: %@", appSupportDir);
        return YES;
    }
    if (!isDirectory) {
        NSLog(@"The application support dir exists but is not a directory... what?");
    }
    NSError *error;
    BOOL success = [[NSFileManager defaultManager]
                    createDirectoryAtPath:appSupportDir
                    withIntermediateDirectories:NO
                    attributes:nil
                    error:&error];
    if (!success) {
        return NO;
    }
    NSLog(@"%@ has been created.", appSupportDir);
    return YES;
}

- (IBAction)openHelpPage:(id)sender{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://blog.parkermoore.de/Responding/"]];
}

@end
