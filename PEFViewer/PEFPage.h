//
//  PEFPage.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-12-03.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PEFRow;

@interface PEFPage : NSObject

@property NSUInteger index;
@property (readonly) NSArray *rows;
@property NSUInteger width;
@property NSUInteger height;
- (void)addRow:(PEFRow *)row;
- (id)initWithWidth:(int)w height:(int)h;
@end
