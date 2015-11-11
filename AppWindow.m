//
//  AppWindow.m
//  NoteTaker
//
//  Created by James Enciso on 8/22/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "AppWindow.h"
#include <stdlib.h>


@implementation AppWindow

@synthesize inputField, notesList, addNoteButton, deleteNoteButton, saveStatusLabel;
@synthesize notesListData;
@synthesize FILENAME;


- (void) awakeFromNib{

	notesList.dataSource = self;
	notesList.delegate = self;
	inputField.delegate = self;
	
	FILENAME =[@"Fill.stt" stringByExpandingTildeInPath];

	[saveStatusLabel setStringValue:@""];

		
	//check if can load previous file contents
	{
		NSArray *arr = [[NSArray alloc] initWithContentsOfFile:FILENAME];
		
		if (arr.count != 0) {
			notesListData = [[NSMutableArray alloc] initWithContentsOfFile:FILENAME];
			[arr dealloc];
			[notesList reloadData];
			
		}
		else {
			notesListData = [[NSMutableArray alloc] init];
			
		}
	}
	//end check block
	
	
	[self makeInputFieldFirstReponder];
	NSLog(@"finished loading");

	if (notesList.selectedRow == -1) {
		[deleteNoteButton setTitle:@"Discard"];
	}
	
}


- (IBAction)deleteNoteClicked:(id)sender{

	NSLog(@"Delete Button Clicked");
	
	//check if selected a row and table is currently enabled (not in edit mode), delete item
	if (notesList.selectedRow < notesListData.count && [self isInEditMode] == NO) {
		[notesListData removeObjectAtIndex:[notesList selectedRow]];
		[notesList reloadData];

	}
	//check if in edit mode: discard changes (set input back to original text)
	else if ([self isInEditMode] == YES) {
		[self setEditMode:NO];
		[self setSaveStatusUnsaved:NO];
		[inputField setString:[notesListData objectAtIndex:[notesList selectedRow]]];
	}
	

	//if nothing selected (new note mode), use discard button to reset field
	else if([notesList selectedRow] == -1){
		[inputField setString:@""];
		[self makeInputFieldFirstReponder];
		[self setSaveStatusUnsaved:NO];
	
	}

}

- (IBAction)addnoteClicked:(id)sender{
	
 
	NSString *str = [[inputField string] copy];
	//NSLog(@"input: %@", str);
	
	//if nothing selected, add note as new entry
	if (notesList.selectedRow == -1) {

		//check if contains a blank entry. Halt if blank
		if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
			NSAlert *alert = [NSAlert alertWithMessageText:@"Empty Note Entry" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Make sure your note is not blank"];
			[alert runModal];	
			return;
		}
		
		//if blank entry check passed, add new entry
			NSLog(@"Add Button Clicked");		
			[notesListData addObject:str];
			[inputField setString:@""];
			
			//autoscrolls to bottom to show newly inputted entry
			[notesList reloadData];
			NSInteger scrollPosition = notesListData.count - 1;
			[notesList scrollRowToVisible:scrollPosition];
			

	}
	//if row selected, edit currently selected row
	else {
		NSLog(@"update button clicked");
//		str = [[inputField string] copy];

		[notesListData replaceObjectAtIndex:[notesList selectedRow] withObject:str];
		
	}
	
	[self makeInputFieldFirstReponder];
	
	FILENAME =[@"Fill.stt" stringByExpandingTildeInPath];
	[notesListData writeToFile:FILENAME atomically:YES];
	
	[notesList reloadData];

	
	[self setSaveStatusUnsaved:NO];
	[self setEditMode:NO];
	
	if (notesList.selectedRow == -1) {
		[deleteNoteButton setTitle:@"Discard"];
	}
	
}


- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView{	
	
	return notesListData.count;

}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex{

	id returnValue=nil;

		
	// The column identifier string is the easiest way to identify a table column.
    NSString *columnIdentifer = [tableColumn identifier];
	
    // Get the name at the specified row in namesArray
    NSString *theName = [notesListData objectAtIndex:rowIndex];
	
	
    // Compare each column identifier and set the return value to
    // the Person field value appropriate for the column.
    if ([columnIdentifer isEqualToString:@"tablecolumnname"]) {
        returnValue = theName;
    }
	
	
    return returnValue;
	
}

- (BOOL) tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{

	//sets  the input field to the contents of the selected row
	[inputField setString:[notesListData objectAtIndex:row]];
	[self setSaveStatusUnsaved:NO];
	
	return YES;
	
}

- (void) textDidChange:(NSNotification *)notification{

	[self setSaveStatusUnsaved:YES];
	
	//if selected and editing, prevent from selecting until save confirm
	if ([notesList selectedRow] != -1 ) {
		[self setEditMode:YES];
	}
	
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification{

	//if selecting something
	if ([notesList selectedRow] != -1) {
		[addNoteButton setTitle:@"Save"];
		[deleteNoteButton setTitle:@"Delete Note"];
		[deleteNoteButton setEnabled:YES];

	}
	else {
		//if not selecting anything
		[addNoteButton setTitle:@"Add Note"];
		[inputField setString:@""];
		[self makeInputFieldFirstReponder];
		[deleteNoteButton setTitle:@"Discard"];

		//[deleteNoteButton setEnabled:NO];

		
	}
	
}

//---------------CORE FUNCTIONS----------------------

- (void) makeInputFieldFirstReponder{

	[[inputField window] makeFirstResponder:inputField];


}

//sets the parameters for editing. Prevents losing data
- (void)setEditMode:(BOOL)mode{

	if (mode == YES) {
		[notesList setEnabled:NO];
		[deleteNoteButton setTitle:@"Discard"];
		[addNoteButton setTitle:@"Save"];

	}
	else {
		[notesList setEnabled:YES];
		[deleteNoteButton setTitle:@"Delete Note"];
	}

}

//returns the status of whether the app is in edit mode or not.
//based on pre-defined conditions that make it in edit mode
- (BOOL)isInEditMode{

	if ([notesList selectedRow] != -1 && [notesList isEnabled] == NO) {
		return YES;
	}
	else if (notesList.selectedRow != -1 && [notesList isEnabled] == YES) {
		return NO;
	}

	return NO;

}


//sets the save status label to it's respective message
- (void)setSaveStatusUnsaved:(BOOL)value{

	if (value == YES) {
		//[notesList setEnabled:NO];
		[saveStatusLabel setStringValue:@"Unsaved Note"];
		[saveStatusLabel setTextColor:[NSColor redColor]];
	}
	else if(value == NO) {
		//[notesList setEnabled:NO];
		[saveStatusLabel setStringValue:@""];
		[saveStatusLabel setTextColor:[NSColor blackColor]];
	}


}

@end
