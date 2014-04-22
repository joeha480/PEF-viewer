//
//  PEFConfig.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-03-01.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PEFBrailleTable;

@interface PEFBrailleTableFactory : NSObject
@property (readonly) NSArray *tables;
@property PEFBrailleTable *selectedTable;
@property (nonatomic) NSUInteger selectedTableIndex;
@end
