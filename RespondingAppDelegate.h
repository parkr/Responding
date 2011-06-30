//
//  RespondingAppDelegate.h
//  Responding
//
//  Created by Parker Moore on 6/28/11.
//  Copyright 2011 Parker Moore. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RespondingAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)openHelpPage:(id)sender;

@end
