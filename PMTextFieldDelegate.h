//
//  PMTextFieldDelegate.h
//  Responding
//
//  Created by Parker Moore on 6/29/11.
//  Copyright 2011 Parker Moore. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PMBaseHeight 622
#define PMBaseWidthMessage 528
#define PMBaseWidthResponse 552

@interface PMTextFieldDelegate : NSObject <NSTextFieldDelegate> {
	IBOutlet NSTextField *message;
	IBOutlet NSTextField *response;
	NSSize messageSize;
	NSSize responseSize;
}

- (IBAction)changeSizeOfMessage:(id)sender;
- (IBAction)changeSizeOfResponse:(id)sender;
- (void)controlTextDidChange:(NSNotification *)aNotification;

@end
