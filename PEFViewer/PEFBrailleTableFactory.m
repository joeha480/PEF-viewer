//
//  PEFConfig.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-03-01.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import "PEFBrailleTableFactory.h"
#import "PEFBrailleTable.h"

static NSString *TABLE_INDEX_KEY = @"TABLE_INDEX_KEY";

@interface PEFBrailleTableFactory()
@end

@implementation PEFBrailleTableFactory
@synthesize tables = _tables;
@synthesize selectedTable = _selectedTable;
@synthesize selectedTableIndex = _selectedTableIndex;


- (id)init
{
	self = [super init];
	if (self) {
		_tables = @[
					[[PEFBrailleTable alloc] initWithName:@"English (lower case)"
											  description:@""
													table:@" a1b'k2l`cif/msp\"e3h9o6r~djg>ntq,*5<-u8v.%{$+x!&;:4|0z7(_?w}#y)="],
					[[PEFBrailleTable alloc] initWithName:@"Danish"
											  description:@""
													table:@" a,b.k;l'cif/msp`e:h*o!r~djgæntq@å?ê-u(v\\îøë§xèç^û_ü)z\"à|ôwï#yùé"],
					[[PEFBrailleTable alloc] initWithName:@"German"
											  description:@""
													table:@" a,b.k;l\"cif|msp!e:h*o+r>djg`ntq'1?2-u(v$3960x~&<5/8)z={_4w7#y}%"],
					/*
					[[PEFBrailleTable alloc] initWithName:@"Danish"
											  description:@""
													table:@""],*/
					[[PEFBrailleTable alloc] initWithName:@"Swedish (CX)"
											  description:@"Matches the Swedish representation in CX"
													table:@" a,b.k;l^cif/msp'e:h*o!r~djgäntq_å?ê-u(v@îöë§xèç\"û+ü)z=à|ôwï#yùé"]
					
					];
		//returns 0 if value was not stored
		self.selectedTableIndex = [[NSUserDefaults standardUserDefaults] integerForKey:TABLE_INDEX_KEY];
	}
	return self;
}

- (void)setSelectedTableIndex:(NSUInteger)selectedTableIndex
{
	_selectedTableIndex = selectedTableIndex % self.tables.count;
	[self updateSelectedTable];
}
#pragma mark - private methods
- (void)updateSelectedTable
{
	_selectedTable = [self.tables objectAtIndex:self.selectedTableIndex];
	[[NSUserDefaults standardUserDefaults] setInteger:self.selectedTableIndex forKey:TABLE_INDEX_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
@end
