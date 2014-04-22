//
//  PEFSize.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-01-12.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import "PEFAttributes.h"

@implementation PEFAttributes
@synthesize width = _width;
@synthesize height = _height;
@synthesize duplex = _duplex;
@synthesize rowgap = _rowgap;

- (id)initWitWidth:(int)w height:(int)h duplex:(BOOL)d rowgap:(int)rg
{
	self = [super init];
	if (self) {
		_width = w;
		_height = h;
		_duplex = d;
		_rowgap = rg;
	}
	return self;
}
@end
