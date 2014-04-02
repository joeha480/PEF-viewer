//
//  PEFPage.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-12-03.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import "PEFPage.h"
#import "PEFRow.h"

@interface PEFPage()
@property (strong) NSMutableArray *data;
@end

@implementation PEFPage
@synthesize width = _width;
@synthesize height = _height;
@synthesize data = _data;

- (id)initWithWidth:(int)w height:(int)h
{
	self = [super init];
	if (self) {
		_width = w;
		_height = h;
		_data = [[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
}

- (void)addRow:(PEFRow *)data {
	[self.data addObject:data];
}

- (NSArray *)rows
{
	return [self.data copy];
}

@end
