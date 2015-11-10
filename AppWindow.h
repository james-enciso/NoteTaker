//
//  AppWindow.h
//  NoteTaker
//
//  Created by James Enciso on 8/22/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

//This class controls the main app window

#import <Cocoa/Cocoa.h>

@interface AppWindow : NSWindowController <NSTableViewDelegate, NSTableViewDataSource, NSTextViewDelegate> {

	NSTextView *inputField;
	NSTableView *notesList;
	NSButton *addNoteButton;
	NSButton *deleteNoteButton;
	NSMutableArray *notesListData;
	NSString *FILENAME;
	
	NSTextField *saveStatusLabel;
	
}

@property (nonatomic, retain) IBOutlet NSTextView *inputField;
@property (nonatomic, retain) IBOutlet NSTableView *notesList;
@property (nonatomic, retain) IBOutlet NSButton *addNoteButton;
@property (nonatomic, retain) IBOutlet NSButton *deleteNoteButton;
@property (nonatomic, retain)  NSString *FILENAME;

@property (nonatomic, retain) IBOutlet NSTextField *saveStatusLabel;



//table view data source
@property (nonatomic, retain) NSMutableArray *notesListData;


-(IBAction)deleteNoteClicked:(id)sender;
-(IBAction)addnoteClicked:(id)sender;


//CORE FUNCTIONS
-(void)makeInputFieldFirstReponder;
-(void)setSaveStatusUnsaved:(BOOL)value;
-(BOOL)isInEditMode;
-(void)setEditMode:(BOOL)mode;

@end
