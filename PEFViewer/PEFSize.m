//
//  PEFSize.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-01-12.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import "PEFSize.h"

@implementation PEFSize
@synthesize width = _width;
@synthesize height = _height;

- (id)initWitWidth:(int)w height:(int)h
{
	self = [super init];
	if (self) {
		_width = w;
		_height = h;
	}
	return self;
}
@end
