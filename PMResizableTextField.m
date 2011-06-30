//
//  PMResizableTextField.m
//  Responding
//
//  Created by Parker Moore on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	A modification of this code: http://www.cocoadev.com/index.pl?CCDGrowingTextField

#import "PMResizableTextField.h"


@implementation PMResizableTextField

- (id)initWithFrame:(NSRect)frame {
	if (self = [super initWithFrame:frame]){
		baseFrame = frame;
	}
	NSLog(@"Initialized with frame %@", baseFrame);
	return self;
}

- (id)initWithCoder:(NSCoder*)coder {
	if (self = [super initWithCoder:coder]) baseFrame = [self frame];	
	return self;
}

- (NSRect)baseFrame { return baseFrame; }

- (void)setBaseFrame:(NSRect)frame {
	baseFrame = frame;
}

- (void)sizeToFit {
	NSRect frame = [self frame];
	frame.size.height = [self contentSize].height+10;
	NSLog(@"frame.size.height = %f ||| String is empty: %d", frame.size.height, [[self stringValue] isEqualToString:@""] == TRUE);
	if (frame.size.height < PMBaseHeight) {
		frame.size.height = PMBaseHeight;
	}
	[self setFrame:frame];
	NSLog(@"Set to frame: w %f, h %f", frame.size.width, frame.size.height);
}

- (void)textDidChange:(NSNotification *)aNotification {
	if ([[self stringValue] isEqualToString:@""]) {
		[self setFrame:baseFrame];
		return;
	}
	NSLog(@"Text changed.");
	[self sizeToFit];
}

- (NSSize)contentSize {
	NSTextView *textView = (NSTextView*)[[self window] fieldEditor:YES forObject:self];
	NSSize contentSize = [[textView layoutManager] usedRectForTextContainer:[textView textContainer]].size;
	NSLog(@"height: %f", contentSize.height);
	return contentSize;
}

@end
