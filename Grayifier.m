//
//  Grayifier.m
//  GrayFocus
//
//  Created by Andy Matuschak on 8/5/10.
//  Copyright 2010 Andy Matuschak. All rights reserved.
//

#import "Grayifier.h"


@implementation Grayifier

static NSMapTable *mapTable = nil;

+ (void)load
{
	mapTable = [[NSMapTable mapTableWithWeakToStrongObjects] retain];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grayify:) name:NSWindowDidResignKeyNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(grayify:) name:NSWindowDidResignMainNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorize:) name:NSWindowDidBecomeMainNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorize:) name:NSWindowDidBecomeKeyNotification object:nil];
}

+ (void)grayify:(NSNotification *)note
{
	NSWindow *window = [note object];
	if (![[window colorSpace] isEqual:[NSColorSpace genericGrayColorSpace]])
		[mapTable setObject:[window colorSpace] forKey:window];
	[window setColorSpace:[NSColorSpace genericGrayColorSpace]];
}

+ (void)colorize:(NSNotification *)note
{
	NSWindow *window = [note object];
	NSColorSpace *space = [mapTable objectForKey:window];
	if (!space)
		space = [NSColorSpace genericRGBColorSpace];
	[window setColorSpace:[NSColorSpace genericRGBColorSpace]];
}

@end
