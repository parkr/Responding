//
//  Message.h
//  Responding
//
//  Created by Parker Moore on 6/28/11.
//  Copyright 2011 Parker Moore. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PMResizableTextField.h"

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
#define PMNewPersonText @"Add a recipient"
#define PMNewPersonLongText @"To whom are you writing this response?"
#define PMSelectAPersonText @". Please select a recipient or create a new one to begin."
#define PMNewPersonCreated @"New recipient created."

#define PMConcatenateToString(old, add) ([old stringByAppendingString:add])
#define PMErrorSavingFiles(errorMessage) ([NSString stringWithFormat:@"Error occurred during saving: %@", errorMessage])

#define PMCurrentPerson [[peopleArray objectAtIndex:indexOfCurrentPerson] lowercaseString]
#define PMMessageTo(name) [[NSString alloc] initWithFormat:@"message_to_%@.txt", name]
#define PMResponseTo(name) [[NSString alloc] initWithFormat:@"response_to_%@.txt", name]

#define PMKeyPeople @"recipients"
#define PMKeyFontName @"font"
#define PMKeyFontSize @"fontSize"

@interface PMMessage : NSObject {
	IBOutlet PMResizableTextField *message;
	IBOutlet PMResizableTextField *response;
	IBOutlet NSTextField *status;
	IBOutlet NSPopUpButton *people;
	IBOutlet NSButton *save;
	IBOutlet NSButton *copy;
	NSString *messageText;
	NSString *responseText;
	NSString *messageFile;
	NSString *responseFile;
	NSString *preferencesFile;
	NSMutableDictionary *preferences;
	NSString *peopleFile;
	NSMutableArray *peopleArray;
	int indexOfCurrentPerson;
	NSString *currentFontName;
	float currentFontSize;
}

- (void)enableInterface;
- (void)disableInterface;

- (IBAction)save:(id)sender;
- (NSString *)filenameForName:(NSString *)name;
- (BOOL)savePrefsToFile;
- (IBAction)copyResponseToClipboard:(id)sender;

- (void)initFont;
- (IBAction)chooseFont:(id)sender;
- (void)setFont;
- (IBAction)enlargeFont:(id)sender;
- (IBAction)shrinkFont:(id)sender;

- (IBAction)changePerson:(id)sender;
- (void)loadPeopleFromFile;
- (void)loadMessagesFromFiles;

@end
