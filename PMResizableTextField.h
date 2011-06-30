//
//  PMResizableTextField.h
//  Responding
//
//  Created by Parker Moore on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	A modification of this code: http://www.cocoadev.com/index.pl?CCDGrowingTextField

#import <Cocoa/Cocoa.h>

#define PMBaseHeight 622
#define PMBaseWidthMessage 528
#define PMBaseWidthResponse 552

@interface PMResizableTextField : NSTextField {
	NSRect baseFrame;
}
- (NSRect)baseFrame;
- (void)setBaseFrame:(NSRect)frame;

- (NSSize)contentSize;

@end
