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

#define PMConcatenateToString(old, add) ([old stringByAppendingString:add])
#define PMErrorSavingFiles(errorMessage) (@"Error occurred during saving: %@", errorMessage)

@interface PMMessage : NSObject {
	IBOutlet NSTextField *message;
	IBOutlet NSTextField *response;
	IBOutlet NSTextField *status;
	NSString *messageFile;
	NSString *responseFile;
	NSString *messageText;
	NSString *responseText;
}

- (IBAction)save:(id)sender;
- (IBAction)copyResponseToClipboard:(id)sender;
- (void)loadFromFiles;

@end
