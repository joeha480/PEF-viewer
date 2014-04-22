//
//  PEFSize.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-01-12.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEFAttributes : NSObject
- (id)initWitWidth:(int)w height:(int)h duplex:(BOOL)d rowgap:(int)rg;
@property (readonly) int width;
@property (readonly) int height;
@property (readonly) BOOL duplex;
@property (readonly) int rowgap;
@end
