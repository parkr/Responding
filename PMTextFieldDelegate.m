//
//  PMTextFieldDelegate.m
//  Responding
//
//  Created by Parker Moore on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PMTextFieldDelegate.h"


@implementation PMTextFieldDelegate

- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector {
	BOOL retval = NO;
	if (commandSelector == @selector(insertNewline:)) {
		retval = YES;
		[fieldEditor insertNewlineIgnoringFieldEditor:nil];
	}
	return retval;
}

@end
