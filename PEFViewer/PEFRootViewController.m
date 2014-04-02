//
//  PEFRootViewController.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-09-02.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import "PEFRootViewController.h"

#import "PEFModelController.h"

#import "PEFDataViewController.h"
#import "PEFBook.h"

@interface PEFRootViewController ()

@end

@implementation PEFRootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	// Configure the page view controller and add it as a child view controller.
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
	self.pageViewController.delegate = self;

	PEFDataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
	NSArray *viewControllers = @[startingViewController];
	[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];

	self.pageViewController.dataSource = self.modelController;

	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];

	// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
	CGRect pageViewRect = self.view.bounds;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
	}
	self.pageViewController.view.frame = pageViewRect;

	[self.pageViewController didMoveToParentViewController:self];

	// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
	self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
	self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleTranslation:)]];
	self.modelController.translating = NO;
	self.title = [[self.modelController.book.url filePathURL] lastPathComponent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - ...

- (NSURL *)docDir
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (paths.count>0) {
		NSLog(@"yes %@", [paths objectAtIndex:0]);
		return [NSURL fileURLWithPath:(NSString *)[paths objectAtIndex:0]];
	} else {
		return nil;
	}
}

#pragma mark - UIPageViewController delegate methods

/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	PEFDataViewController *currentViewController = self.pageViewController.viewControllers[0];
	//[currentViewController setTranslating:self.modelController.translating];
	if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
	    // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
	    
	    NSArray *viewControllers = @[currentViewController];
	    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
	    
	    self.pageViewController.doubleSided = NO;
	    return UIPageViewControllerSpineLocationMin;
	}

	// In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.

	NSArray *viewControllers = nil;

	NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
	if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
	    UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
	    viewControllers = @[currentViewController, nextViewController];
	} else {
	    UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
	    viewControllers = @[previousViewController, currentViewController];
	}
	[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];


	return UIPageViewControllerSpineLocationMid;
}

#pragma mark - Toolbar actions
- (void)toggleTranslation:(id)sender
{
	self.modelController.translating = !self.modelController.translating;
	NSDictionary *d = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:self.modelController.translating]] forKeys:@[@"translating"]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PEF-update" object:self userInfo:d];
	/*
	for (PEFDataViewController *vc in self.pageViewController.viewControllers) {
		[vc setTranslating:self.modelController.translating];
	}*/
}

@end
