//
//  PEFBrailleTable.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-03-01.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEFBrailleTable : NSObject
@property (readonly) NSString *tName;
@property (readonly) NSString *tDescription;
@property (readonly) NSString *table;

- (id)initWithName:(NSString *)name description:(NSString *)desc table:(NSString *)table;
@end
