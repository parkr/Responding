//
//  Message.m
//  Responding
//
//  Created by Parker Moore on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PMMessage.h"


@implementation PMMessage

- (void)awakeFromNib {
	NSLog(@"Awoken!");
	[status setStringValue:PMInitializedText];
	//NSFont *font = [NSFont fontWithName:@"Kozuka Mincho Pro" size:16.0];
	NSFont *font = [NSFont fontWithName:@"Helvetica" size:16.0];
	response.font = font;
	message.font = font;
	[self loadFromFiles];
}

- (IBAction)save:(id)sender {
	[status setStringValue:PMSavingText];
	// Get text and put in buffer.
	messageText = [message stringValue];
	responseText = [response stringValue];
	// Write to text files.
	NSError *error;
	if(![messageText writeToFile:messageFile atomically:YES encoding:NSUTF8StringEncoding error:&error] || ![responseText writeToFile:responseFile atomically:YES encoding:NSUTF8StringEncoding error:&error]){
		NSLog(@"We have a problem: %@", [error localizedFailureReason]);
		[status setStringValue:PMErrorSavingFiles([error localizedFailureReason])];
	}else{
		NSLog(@"Saved!");
		[status setStringValue:PMSavedText];
	}
}

- (IBAction)copyResponseToClipboard:(id)sender {
	// Take everything from response and put it in the clipboard.
	NSPasteboard *pboard = [NSPasteboard generalPasteboard];
	[pboard clearContents];
	if ([pboard setString:[response stringValue] forType:NSStringPboardType]) {
		[status setStringValue:PMCopiedText];
	}else{
		[status setStringValue:PMCopiedFailedText];
	}
}

- (void)loadFromFiles {
	// Load text from files. We will use 2 separate files, one for the response, one for the message.
	
	// Do they exist?
	NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *folderPath = [[libPath stringByAppendingPathComponent:@"Application Support"] stringByAppendingPathComponent:@"Responding"];
	messageFile = [folderPath stringByAppendingPathComponent:@"message.txt"];
	responseFile = [folderPath stringByAppendingPathComponent:@"response.txt"];
	BOOL yah = YES;
	NSLog(@"%@\n%@\n%@", folderPath, messageFile, responseFile);
	if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&yah]) {
		// Folder exists. Do the files?
		if ([[NSFileManager defaultManager] fileExistsAtPath:messageFile] && [[NSFileManager defaultManager] fileExistsAtPath:responseFile]) {
			// Load.
			NSLog(@"They exist!");
			messageText = [[NSString alloc] initWithContentsOfFile:messageFile];
			responseText = [[NSString alloc] initWithContentsOfFile:responseFile];
			[message setStringValue:messageText];
			[response setStringValue:responseText];
			[status setStringValue:PMConcatenateToString([status stringValue], PMInitializedWithOldText)];
		}else{
			// Init with new.
			messageText = [[NSString alloc] init];
			responseText = [[NSString alloc] init];
			[status setStringValue:PMConcatenateToString([status stringValue], PMInitializedWithNewText)];
		}
	}else{
		// Nothing exists.
		if(![[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL]){
			NSLog(@"Error: Create folder failed %@", folderPath);
			messageText = [[NSString alloc] init];
			responseText = [[NSString alloc] init];
			[status setStringValue:@"Could not create folder. Please quit and relaunch the program."];
		}else {
			// Create files.
			messageText = [[NSString alloc] init];
			responseText = [[NSString alloc] init];
			[status setStringValue:PMConcatenateToString([status stringValue], PMInitializedWithNewText)];
		}
	}
	[messageFile retain];
	[responseFile retain];
}

- (void)dealloc {
	[messageFile release];
	[responseFile release];
	[super dealloc];
}

@end
