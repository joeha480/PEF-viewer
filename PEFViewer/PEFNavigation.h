//
//  PEFNavigation.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-04-13.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PEFNavigation <NSObject>

- (NSUInteger)countVolumes;
- (NSUInteger)countSectionsInVolume:(NSUInteger)volume;
- (void)didCancelSelection;
- (void)didSelectSection:(NSUInteger)section volume:(NSUInteger)volume;

@end
