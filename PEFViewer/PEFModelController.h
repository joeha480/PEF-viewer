//
//  PEFModelController.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-09-02.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PEFDataViewController;
@class PEFBook;
@class PEFBrailleTable;

@interface PEFModelController : NSObject <UIPageViewControllerDataSource>

@property (nonatomic, getter=isTranslating) BOOL translating;
@property (readonly) PEFBook* book;
@property (readonly) PEFBrailleTable *table;

- (id)initWithURL:(NSURL *)url volume:(int)vol config:(PEFBrailleTable *)table;
- (PEFDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(PEFDataViewController *)viewController;

@end
