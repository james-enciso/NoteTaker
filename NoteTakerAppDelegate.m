//
//  NoteTakerAppDelegate.m
//  NoteTaker
//
//  Created by James Enciso on 8/22/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "NoteTakerAppDelegate.h"
#import "AppWindow.h"

@implementation NoteTakerAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	NSWindowController *winC = [[NSWindowController alloc] initWithWindowNibName:@"AppWindow"];
	[winC loadWindow];
	
	//[interfaceWindow LoadWindow];
	
//	NSWindowController *previewWindow;
//	previewWindow = [[NSWindowController alloc] initWithWindowNibName:@"AppWindow"];
//	[previewWindow showWindow:nil];
	
	

}


@end
