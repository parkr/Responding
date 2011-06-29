//
//  Message.h
//  Responding
//
//  Created by Parker Moore on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PMInitializedText @"Initialized"
#define PMInitializedWithNewText @" as a new response."
#define PMInitializedWithOldText @" with a previous message."
#define PMInitializedErrorText @"There was an error during initialization."
#define PMSavedText @"Saved."
#define PMSavingText @"Saving..."
#define PMCopiedText @"Copied to clipboard."
#define PMCopiedFailedText @"Copy to clipboard failed."

#define PMPeopleFoundText @"Respondees have been found."
#define PMNoPeopleFoundTitle @"No Respondees"
#define PMNoPeopleFoundText @"No existing repondees were found."
#define PMResponseFoundButNoPeopleText @"A message and response pair was found, but no name. Who is it for?"
#define PMNewPersonText @"To whom are you writing this response?"
#define PMSelectAPersonText @". Please select a recipient or create a new one to begin."
#define PMNewPersonCreated @"New recipient created."

#define PMConcatenateToString(old, add) ([old stringByAppendingString:add])
#define PMErrorSavingFiles(errorMessage) (@"Error occurred during saving: %@", errorMessage)

#define PMCurrentPerson [[peopleArray objectAtIndex:indexOfCurrentPerson] lowercaseString]
#define PMMessageTo(name) [[NSString alloc] initWithFormat:@"message_to_%@.txt", name]
#define PMResponseTo(name) [[NSString alloc] initWithFormat:@"response_to_%@.txt", name]

#define PMHelveticaFont [NSFont fontWithName:@"Helvetica" size:16.0]
#define PMKozukaFont [NSFont fontWithName:@"Kozuka Mincho Pro" size:16.0]

@interface PMMessage : NSObject {
	IBOutlet NSTextField *message;
	IBOutlet NSTextField *response;
	IBOutlet NSTextField *status;
	IBOutlet NSPopUpButton *people;
	IBOutlet NSButton *save;
	IBOutlet NSButton *copy;
	NSString *messageText;
	NSString *responseText;
	NSString *messageFile;
	NSString *responseFile;
	NSString *peopleFile;
	NSMutableArray *peopleArray;
	int indexOfCurrentPerson;
}

- (void)enableInterface;
- (void)disableInterface;

- (IBAction)save:(id)sender;
- (BOOL)savePeopleToFile;
- (IBAction)copyResponseToClipboard:(id)sender;

- (IBAction)chooseFont:(id)sender;
- (void)setFont:(NSFont *)aFont;

- (IBAction)changePerson:(id)sender;
- (void)loadPeopleFromFiles;
- (void)loadMessagesFromFiles;

@end
