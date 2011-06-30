//
//  PMTextFieldDelegate.m
//  Responding
//
//  Created by Parker Moore on 6/29/11.
//  Copyright 2011 Parker Moore. All rights reserved.

#import "PMTextFieldDelegate.h"


@implementation PMTextFieldDelegate

- (id)init{
	[super init];
	messageSize = NSMakeSize(PMBaseWidthMessage, PMBaseHeight);
	responseSize = NSMakeSize(PMBaseWidthResponse, PMBaseHeight);
	return self;
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector {
	BOOL retval = NO;
	if (commandSelector == @selector(insertNewline:)) {
		retval = YES;
		[fieldEditor insertNewlineIgnoringFieldEditor:nil];
	}
	return retval;
}

- (IBAction)changeSizeOfMessage:(id)sender{
	NSString *command = [sender title];
	NSLog(@"Message Command: '%@'", command);
	NSSize newSize;
	if ([command compare:@"Base Size"] == NSOrderedSame) {
		newSize = NSMakeSize(PMBaseWidthMessage, PMBaseHeight);
	}else if ([command compare:@"1000px"] == NSOrderedSame) {
		newSize = NSMakeSize(PMBaseWidthMessage, 1000);
	}else if ([command compare:@"Increase by 250px"] == NSOrderedSame) {
		newSize = messageSize;
		newSize.height = newSize.height + 250;
	}else if ([command compare:@"Decrease by 250px"] == NSOrderedSame) {
		newSize = messageSize;
		newSize.height = newSize.height - 250;
	}
	if (newSize.height < PMBaseHeight) {
		newSize = NSMakeSize(PMBaseWidthMessage, PMBaseHeight);
	}
	[message setFrameSize:newSize];
	messageSize = newSize;
}

- (IBAction)changeSizeOfResponse:(id)sender{
	NSString *command = [sender title];
	NSLog(@"Message Command: '%@'", command);
	NSSize newSize;
	if ([command compare:@"Base Size"] == NSOrderedSame) {
		newSize = NSMakeSize(PMBaseWidthResponse, PMBaseHeight);
	}else if ([command compare:@"1000px"] == NSOrderedSame) {
		newSize = NSMakeSize(PMBaseWidthResponse, 1000);
	}else if ([command compare:@"Increase by 250px"] == NSOrderedSame) {
		newSize = responseSize;
		newSize.height = newSize.height + 250;
	}else if ([command compare:@"Decrease by 250px"] == NSOrderedSame) {
		newSize = responseSize;
		newSize.height = newSize.height - 250;
	}
	if (newSize.height < PMBaseHeight) {
		newSize = NSMakeSize(PMBaseWidthResponse, PMBaseHeight);
	}
	[response setFrameSize:newSize];
	responseSize = newSize;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
	NSLog(@"Text should end editing!");
	return YES;
}

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification {
	NSLog(@"Started editing");
	[[aNotification object] sizeToFit];
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
	NSLog(@"Text has changed!");
	[[aNotification object] sizeToFit];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
	NSLog(@"controlTextDidEndEditing: has been called.");
	[[aNotification object] sizeToFit];
}

@end
