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
- (NSUInteger)sectionsInVolume:(NSUInteger)volume;
- (NSUInteger)indexOfFirstPageInSection:(NSUInteger)section volume:(NSUInteger)volume;
- (void)abortLoading;

@property (readonly) NSUInteger volumes;
@property (readonly) NSURL *url;
@property (readonly) BOOL loaded;
@property NSMutableArray *sectionsInVolume;
@property NSMutableDictionary* metadata;
@property NSMutableArray* errors;
@property NSMutableArray* warnings;

@end
