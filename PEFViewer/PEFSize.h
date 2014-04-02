//
//  PEFSize.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-01-12.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEFSize : NSObject
- (id)initWitWidth:(int)w height:(int)h;
@property (readonly) int width;
@property (readonly) int height;
@end
