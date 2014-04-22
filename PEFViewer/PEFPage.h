//
//  PEFPage.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-12-03.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PEFRow;
@class PEFAttributes;

@interface PEFPage : NSObject

@property NSUInteger index;
@property NSUInteger volumeNumber;
@property NSUInteger sectionNumber;
@property NSUInteger pageNumber;
@property (readonly) NSArray *rows;
@property NSUInteger width;
@property NSUInteger height;
- (void)addRow:(PEFRow *)row;
- (id)initWithAttributes:(PEFAttributes *)atts;
@end
