//
//  Message.m
//  Responding
//
//  Created by Parker Moore on 6/28/11.
//  Copyright 2011 Parker Moore. All rights reserved.
//

#import "PMMessage.h"


@implementation PMMessage

- (id)init {
	[super init];
	indexOfCurrentPerson = -1;
	NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *folderPath = [[libPath stringByAppendingPathComponent:@"Application Support"] stringByAppendingPathComponent:@"Responding"];
	preferencesFile = [folderPath stringByAppendingPathComponent:@"data.plist"];
	[preferencesFile retain];
	if([[NSFileManager defaultManager] fileExistsAtPath:preferencesFile]){
		NSLog(@"Found prefs: %@", preferencesFile);
		preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:preferencesFile];
		NSLog(@"%@", preferences);
	}else{
		preferences = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					   @"Helvetica", PMKeyFontName, 16.0, PMKeyFontSize, [[NSArray alloc] init], PMKeyPeople, nil];
		[preferences writeToFile:preferencesFile atomically:YES];
	}
	[self loadPeopleFromFile];
	[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(save:) userInfo:nil repeats:YES];
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
	NSLog(@"Awoken! %@", peopleArray);
	[people addItemsWithTitles:peopleArray];
	NSLog(@"People added.");
	if (indexOfCurrentPerson >= 0) {
		[self loadMessagesFromFiles];
		[self enableInterface];
		[message sizeToFit];
		[response sizeToFit];
	}else{
		[status setStringValue:PMConcatenateToString([status stringValue], PMSelectAPersonText)];
		[self disableInterface];
	}
	[self initFont];
}

- (IBAction)save:(id)sender {
	if (indexOfCurrentPerson != -1) {
		[status setStringValue:PMSavingText];
		// Get text and put in buffer.
		messageText = [message stringValue];
		responseText = [response stringValue];
		NSLog(@"%@, %@", messageFile, responseFile);
		// Write to text files.
		NSError *error;
		if(![messageText writeToFile:messageFile atomically:YES encoding:NSUTF8StringEncoding error:&error] || ![responseText writeToFile:responseFile atomically:YES encoding:NSUTF8StringEncoding error:&error] || ![self savePrefsToFile]){
			NSLog(@"We have a problem: %@", [error localizedFailureReason]);
			[status setStringValue:PMErrorSavingFiles([error localizedFailureReason])];
		}else{
			NSLog(@"Saved!");
			[status setStringValue:PMSavedText];
		}
	}else {
		[self savePrefsToFile];
		[status setStringValue:PMErrorSavingFiles(@"no recipient chosen.")];
	}
}

- (BOOL)savePrefsToFile {
	NSLog(@"Preferences saved to %@", preferencesFile);
	[preferences setObject:peopleArray forKey:PMKeyPeople];
	return [preferences writeToFile:preferencesFile atomically:YES];
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

- (void)initFont {
	currentFontName = [[NSString alloc] initWithString:[preferences objectForKey:PMKeyFontName]];
	[currentFontName retain];
	currentFontSize = [[preferences objectForKey:PMKeyFontSize] floatValue];
	[self setFont];
}

- (IBAction)chooseFont:(id)sender{
	NSLog(@"%@", [sender title]);
	[currentFontName release];
	currentFontName = [[NSString alloc] initWithString:[sender title]];
	[currentFontName retain];
	[self setFont];
}

- (void)setFont {
	NSFont *newFont = [NSFont fontWithName:currentFontName size:currentFontSize];
	response.font = newFont;
	message.font = newFont;
	NSLog(@"Font set to %@ at size %f", currentFontName, currentFontSize);
	[preferences setObject:[NSString stringWithFormat:@"%f", currentFontSize] forKey:PMKeyFontSize];
	[preferences setObject:[NSString stringWithFormat:@"%@", currentFontName] forKey:PMKeyFontName];
}

- (IBAction)enlargeFont:(id)sender{
	currentFontSize += 1.0;
	[self setFont];
}

- (IBAction)shrinkFont:(id)sender{
	 currentFontSize -= 1.0;
	 [self setFont];
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
		
		NSAlert *chooseAPerson = [NSAlert alertWithMessageText:PMNewPersonText
												 defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil
									 informativeTextWithFormat:PMNewPersonLongText];
		[chooseAPerson setAlertStyle:NSInformationalAlertStyle];
		[chooseAPerson setAccessoryView:accessory];
		[chooseAPerson runModal];
		// GET THAT RESPONSE!!!
		NSString *person = [accessory stringValue];
		if ([person isEqualToString:@""]) {
			return;
		}
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
		[self savePrefsToFile];
		[self enableInterface];
	}else{
		NSLog(@"Changing to '%@'", tempPerson);
		// Load the messages!
		indexOfCurrentPerson = [peopleArray indexOfObject:tempPerson];
		NSLog(@"Index of current person: %d", indexOfCurrentPerson);
		[status setStringValue:PMInitializedText];
		[self loadMessagesFromFiles];
		[self enableInterface];
	}
}

- (void)loadPeopleFromFile {
	if (preferences != NULL) {
		peopleArray = [[preferences objectForKey:PMKeyPeople] mutableCopy];
	}else{
		// Bummer. Must be a fresh install or something.
		NSAlert *chooseAPerson = [[NSAlert alloc] init];
		[chooseAPerson setAlertStyle:NSInformationalAlertStyle];
		[chooseAPerson setMessageText:PMNoPeopleFoundText];
		[chooseAPerson setInformativeText:PMNoPeopleFoundText];
		[chooseAPerson runModal];
		[chooseAPerson release];
		peopleArray = [[NSMutableArray alloc] init];
		[status setStringValue:PMConcatenateToString([status stringValue], PMInitializedWithNewText)];
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
	NSLog(@"\n%@\n%@", messageFile, responseFile);
	if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&yah]) {
		// Folder exists. Do the files?
		if ([[NSFileManager defaultManager] fileExistsAtPath:messageFile] && [[NSFileManager defaultManager] fileExistsAtPath:responseFile]) {
			// Load.
			NSError *error;
			NSLog(@"They exist!");
			[people selectItemWithTitle:[peopleArray objectAtIndex:indexOfCurrentPerson]];
			messageText = [[NSString alloc] initWithContentsOfFile:messageFile encoding:NSUTF8StringEncoding error:&error];
			responseText = [[NSString alloc] initWithContentsOfFile:responseFile encoding:NSUTF8StringEncoding error:&error];
			[message setStringValue:messageText];
			[response setStringValue:responseText];
			[message sizeToFit];
			[response sizeToFit];
			[status setStringValue:PMConcatenateToString([status stringValue], PMInitializedWithOldText)];
		}else{
			// Init with new.
			messageText = [[NSString alloc] init];
			responseText = [[NSString alloc] init];
			[message setStringValue:@""];
			[response setStringValue:@""];
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
			[message setStringValue:@""];
			[response setStringValue:@""];
			[status setStringValue:PMConcatenateToString([status stringValue], PMInitializedWithNewText)];
		}
	}
	[messageFile retain];
	[responseFile retain];
	[self savePrefsToFile];
}

- (void)dealloc {
	[messageFile release];
	[responseFile release];
	[preferencesFile release];
	[currentFontName release];
	[super dealloc];
}

@end
