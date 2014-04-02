//
//  PEFBook.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-12-03.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEFPage.h"

@interface PEFBook : NSObject

- (id)initWithURL:(NSURL *)url;

- (NSUInteger)pageCountInVolume:(NSUInteger)volume;
- (PEFPage *)pageAtIndex:(NSUInteger)index volume:(NSUInteger)volume;
@property (readonly) NSURL *url;
@property NSString* dcCreator;
@property NSString* dcIdentifier;
@property NSString* dcTitle;
@property NSString* dcDate;
@property NSString* dcDescription;

@end
