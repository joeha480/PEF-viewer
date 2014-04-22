//
//  PEFModelController.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-09-02.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import "PEFModelController.h"

#import "PEFDataViewController.h"
#import "PEFBook.h"
#import "PEFDelegate.h"
#import "PEFBrailleTable.h"

static NSString *TRANSLATING_KEY = @"TRANSLATING_KEY";

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface PEFModelController()

@property (readonly) int targetVolume;

@end

@implementation PEFModelController

@synthesize targetVolume = _targetVolume;
@synthesize book = _book;
@synthesize table = _table;

- (id)initWithURL:(NSURL *)url volume:(int)vol config:(PEFBrailleTable *)table
{
    self = [super init];
    if (self) {
		_targetVolume = vol;
		_book = [[PEFBook alloc] initWithURL:url];
		_table = table;
//		_pageData = [[dateFormatter monthSymbols] copy];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableChanged:) name:@"PEFTableChanged" object:nil];

    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PEFDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
	while (!self.book.loaded && (([self.book pageCountInVolume:self.targetVolume] == 0) || (index >= [self.book pageCountInVolume:self.targetVolume]))) {
		if (self.book.errors.count>0) {
			return nil;
		}
		[NSThread sleepForTimeInterval:0.1f];
	}
    if (([self.book pageCountInVolume:self.targetVolume] == 0) || (index >= [self.book pageCountInVolume:self.targetVolume])) {
		NSLog(@"Out of bounds");
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PEFDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"PEFDataViewController"];
	PEFDelegate *d = [[PEFDelegate alloc] init];
	d.dataObject = [self.book pageAtIndex:index volume:self.targetVolume];
	d.controller = self;
	dataViewController.delegate = d;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(PEFDataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return ((PEFPage *)viewController.delegate.dataObject).index;
}

#pragma mark -  Getters/Setters
- (BOOL)isTranslating
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:TRANSLATING_KEY];
}

- (void)setTranslating:(BOOL)translating
{
	[[NSUserDefaults standardUserDefaults] setBool:translating forKey:TRANSLATING_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PEFDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PEFDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.book pageCountInVolume:self.targetVolume]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

#pragma mark - Notifications
- (void) tableChanged:(NSNotification *)notification
{
	_table = [[notification userInfo] objectForKey:@"table"];
}

@end
