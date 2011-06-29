//
//  Message.m
//  Responding
//
//  Created by Parker Moore on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PMMessage.h"


@implementation PMMessage

- (id)init {
	[super init];
	indexOfCurrentPerson = -1;
	[self loadPeopleFromFiles];
	NSLog(@"%@", peopleArray);
	return self;
}

- (void)enableInterface {
	[message setEnabled:YES];
	[response setEnabled:YES];
	[save setEnabled:YES];
	[copy setEnabled:YES];
}

- (void)disableInterface {
	[message setEnabled:NO];
	[response setEnabled:NO];
	[save setEnabled:NO];
	[copy setEnabled:NO];
}

- (void)awakeFromNib {
	NSLog(@"Awoken!");
	[status setStringValue:PMInitializedText];
	[self setFont:PMHelveticaFont];
	[people addItemsWithTitles:peopleArray];
	if (indexOfCurrentPerson >= 0) {
		[self loadMessagesFromFiles];
		[self enableInterface];
	}else{
		[status setStringValue:PMConcatenateToString([status stringValue], PMSelectAPersonText)];
		[self disableInterface];
	}
}

- (IBAction)save:(id)sender {
	[status setStringValue:PMSavingText];
	// Get text and put in buffer.
	messageText = [message stringValue];
	responseText = [response stringValue];
	NSLog(@"%@, %@", messageFile, responseFile);
	// Write to text files.
	NSError *error;
	if(![messageText writeToFile:messageFile atomically:YES encoding:NSUTF8StringEncoding error:&error] || ![responseText writeToFile:responseFile atomically:YES encoding:NSUTF8StringEncoding error:&error] || ![self savePeopleToFile]){
		NSLog(@"We have a problem: %@", [error localizedFailureReason]);
		[status setStringValue:PMErrorSavingFiles([error localizedFailureReason])];
	}else{
		NSLog(@"Saved!");
		[status setStringValue:PMSavedText];
	}
}

- (BOOL)savePeopleToFile {
	return [peopleArray writeToFile:peopleFile atomically:YES];
}

- (IBAction)copyResponseToClipboard:(id)sender {
	[self save:nil];
	// Take everything from response and put it in the clipboard.
	NSPasteboard *pboard = [NSPasteboard generalPasteboard];
	[pboard clearContents];
	if ([pboard setString:[response stringValue] forType:NSStringPboardType]) {
		[status setStringValue:PMCopiedText];
	}else{
		[status setStringValue:PMCopiedFailedText];
	}
}

- (IBAction)chooseFont:(id)sender{
	
}

- (void)setFont:(NSFont *)aFont{
	response.font = aFont;
	message.font = aFont;
}

- (IBAction)changePerson:(id)sender{
	NSString *tempPerson = [[sender selectedItem] title];
	if ([tempPerson compare:@"New..."] == NSOrderedSame) {
		[self save:nil];
		NSLog(@"New person to be created! Hurrah!");
		NSTextField *accessory = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,200,20)];
		NSFont *font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
		NSDictionary *textAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
		[accessory insertText:[[NSAttributedString alloc] initWithString:@"Who was it for?" attributes:textAttributes]];
		[accessory setEditable:YES];
		[accessory setDrawsBackground:NO];
		
		NSAlert *chooseAPerson = [[NSAlert alloc] init];
		[chooseAPerson setAlertStyle:NSInformationalAlertStyle];
		[chooseAPerson setMessageText:PMNewPersonText];
		[chooseAPerson setAccessoryView:accessory];
		[chooseAPerson runModal];
		// GET THAT RESPONSE!!!
		NSString *person = [accessory stringValue];
		[peopleArray addObject:person];
		indexOfCurrentPerson = [peopleArray indexOfObject:person];
		[people addItemWithTitle:person];
		[people selectItemWithTitle:person];
		NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *folderPath = [[libPath stringByAppendingPathComponent:@"Application Support"] stringByAppendingPathComponent:@"Responding"];
		messageFile = [folderPath stringByAppendingPathComponent:PMMessageTo(PMCurrentPerson)];
		responseFile = [folderPath stringByAppendingPathComponent:PMResponseTo(PMCurrentPerson)];
		NSLog(@"Recipient added '%@' at index %d", person, indexOfCurrentPerson);
		NSLog(@"%@, %@", messageFile, responseFile);
		[messageFile retain];
		[responseFile retain];
		[status setStringValue:PMNewPersonCreated];
		[message setStringValue:@""];
		[response setStringValue:@""];
		[self savePeopleToFile];
		[self enableInterface];
	}else{
		NSLog(@"Changing to '%@'", tempPerson);
		// Load the messages!
		indexOfCurrentPerson = [peopleArray indexOfObject:tempPerson];
		NSLog(@"%d", indexOfCurrentPerson);
		[status setStringValue:PMInitializedText];
		[self loadMessagesFromFiles];
		[self enableInterface];
	}
}

- (void)loadPeopleFromFiles {
	NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *folderPath = [[libPath stringByAppendingPathComponent:@"Application Support"] stringByAppendingPathComponent:@"Responding"];
	peopleFile = [folderPath stringByAppendingPathComponent:@"people.plist"];
	[peopleFile retain];
	BOOL yah = YES;
	if([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&yah]){
		// Is the file there?
		if ([[NSFileManager defaultManager] fileExistsAtPath:peopleFile]) {
			// They sure do! Great. Load 'em!
			peopleArray = [[NSMutableArray alloc] initWithContentsOfFile:peopleFile];
		}else{
			// Guess it isn't. Gah!
			peopleArray = [[NSMutableArray alloc] init];
			// Are there left-over message and response files from before?
			messageFile = [folderPath stringByAppendingPathComponent:@"message.txt"];
			responseFile = [folderPath stringByAppendingPathComponent:@"response.txt"];
			if ([[NSFileManager defaultManager] fileExistsAtPath:messageFile] && [[NSFileManager defaultManager] fileExistsAtPath:responseFile]) {
				// They're there! Recover them. But first: ask for a name!
				NSTextField *accessory = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,200,20)];
				NSFont *font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
				NSDictionary *textAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
				[accessory insertText:[[NSAttributedString alloc] initWithString:@"Who was it for?" attributes:textAttributes]];
				[accessory setEditable:YES];
				[accessory setDrawsBackground:NO];
				
				NSAlert *chooseAPerson = [[NSAlert alloc] init];
				[chooseAPerson setAlertStyle:NSInformationalAlertStyle];
				[chooseAPerson setMessageText:PMNoPeopleFoundText];
				[chooseAPerson setInformativeText:PMResponseFoundButNoPeopleText];
				[chooseAPerson setAccessoryView:accessory];
				[chooseAPerson runModal];
				// GET THAT RESPONSE!!!
				NSString *person = [accessory stringValue];
				[peopleArray addObject:person];
				indexOfCurrentPerson = 0;
				NSLog(@"Person was: %@", person);
				// Move files!
				NSString *newPath = [[messageFile stringByDeletingLastPathComponent] stringByAppendingPathComponent:PMMessageTo(PMCurrentPerson)];
				[[NSFileManager defaultManager] moveItemAtPath:messageFile toPath:newPath error:nil];
				newPath = [[responseFile stringByDeletingLastPathComponent] stringByAppendingPathComponent:PMResponseTo(PMCurrentPerson)];
				[[NSFileManager defaultManager] moveItemAtPath:responseFile toPath:newPath error:nil];
				[chooseAPerson release];
			}else {
				// Bummer. Must be a fresh install or something.
				NSAlert *chooseAPerson = [[NSAlert alloc] init];
				[chooseAPerson setAlertStyle:NSInformationalAlertStyle];
				[chooseAPerson setMessageText:PMNoPeopleFoundText];
				[chooseAPerson setInformativeText:PMNoPeopleFoundText];
				[chooseAPerson runModal];
				[chooseAPerson release];
			}
		}
	}else{
		// Nothing exists.
		if(![[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL]){
			NSLog(@"Error: Create folder failed %@", folderPath);
			peopleArray = [[NSMutableArray alloc] init];
			[status setStringValue:@"Could not create folder. Please quit and relaunch the program."];
		}else {
			// Create files.
			peopleArray = [[NSMutableArray alloc] init];
			[status setStringValue:PMConcatenateToString([status stringValue], PMInitializedWithNewText)];
		}
	}
	
}

- (void)loadMessagesFromFiles {
	// Load text from files. We will use 2 separate files, one for the response, one for the message.
	
	// Do they exist?
	NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *folderPath = [[libPath stringByAppendingPathComponent:@"Application Support"] stringByAppendingPathComponent:@"Responding"];
	messageFile = [folderPath stringByAppendingPathComponent:PMMessageTo(PMCurrentPerson)];
	responseFile = [folderPath stringByAppendingPathComponent:PMResponseTo(PMCurrentPerson)];
	BOOL yah = YES;
	NSLog(@"%@\n%@\n%@", folderPath, messageFile, responseFile);
	if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&yah]) {
		// Folder exists. Do the files?
		if ([[NSFileManager defaultManager] fileExistsAtPath:messageFile] && [[NSFileManager defaultManager] fileExistsAtPath:responseFile]) {
			// Load.
			NSLog(@"They exist!");
			[people selectItemWithTitle:[peopleArray objectAtIndex:indexOfCurrentPerson]];
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
	[self savePeopleToFile];
}

- (void)dealloc {
	[messageFile release];
	[responseFile release];
	[super dealloc];
}

@end
