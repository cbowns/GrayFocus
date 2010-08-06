//
//  Grayifier.m
//  GrayFocus
//
//  Created by Andy Matuschak on 8/5/10.
//  Copyright 2010 Andy Matuschak. All rights reserved.
//

#import "Grayifier.h"
#include <Carbon/Carbon.h>
#import "CGSPrivate.h"

extern OSStatus CGSNewConnection(const void **attributes, CGSConnection * id);

@implementation Grayifier

static CGSWindowFilterRef grayscaleFilter;
static CGSConnection connection;

+ (void)load
{
	CGSNewConnection(NULL, &connection);
	CGSNewCIFilterByName(connection, (CFStringRef)@"CIColorControls", &grayscaleFilter);
	CGSSetCIFilterValuesFromDictionary(connection, grayscaleFilter, (CFDictionaryRef)[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"inputSaturation"]);
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grayify:) name:NSWindowDidResignKeyNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grayify:) name:NSWindowDidResignMainNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorize:) name:NSWindowDidBecomeMainNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorize:) name:NSWindowDidBecomeKeyNotification object:nil];
}

+ (void)grayify:(NSNotification *)note
{	
	CGSAddWindowFilter(connection, [(NSWindow *)[note object] windowNumber], grayscaleFilter, 1 << 2);
}

+ (void)colorize:(NSNotification *)note
{
	CGSRemoveWindowFilter(connection, [(NSWindow *)[note object] windowNumber], grayscaleFilter);
}

@end
