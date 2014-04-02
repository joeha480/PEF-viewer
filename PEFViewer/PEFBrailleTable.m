//
//  PEFBrailleTable.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-03-01.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import "PEFBrailleTable.h"

@implementation PEFBrailleTable

@synthesize tName = _tName;
@synthesize tDescription =_tDescription;
@synthesize table = _table;

- (id)initWithName:(NSString *)name description:(NSString *)desc table:(NSString *)table
{
	self = [super init];
	if (self) {
		_tName = name;
		_tDescription = desc;
		_table = table;
	}
	return self;
}
@end
