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
#import "PEFNavigation.h"
#import "PEFNavigationTableViewController.h"
#import "PEFBrailleTableFactory.h"

@interface PEFRootViewController ()<PEFNavigation, UIAlertViewDelegate>
@property UISlider *pageSlider;
@property UIPopoverController *popover;
//@property UIBarButtonItem *pageNumber;
@end

@implementation PEFRootViewController

@synthesize modelController = _modelController;
@synthesize pageSlider = _pageSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self setDetailViewController:self];
	
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
	//self.pageNumber = [[UIBarButtonItem alloc] initWithTitle:@"1" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.pageNumber.title = @"1";
	self.pageSlider = [[UISlider alloc] init];

	self.pageSlider.continuous = YES;
	[self.pageSlider addTarget:self action:@selector(itemSlider:withEvent:) forControlEvents:UIControlEventValueChanged];
	self.sliderButton.customView = self.pageSlider;

	self.sliderButton.width = 150;
	/*
	self.toolbarItems = @[
						  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleTranslation:)],
						  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						  sliderButton,
						  self.pageNumber,
						  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
						  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(navigate:)]
						  ];
	 */
	self.title = [[self.modelController.book.url filePathURL] lastPathComponent];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	[self.view addGestureRecognizer:tap];
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

- (void) viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	NSArray *viewControllers = self.navigationController.viewControllers;
	if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
		// View is disappearing because a new view controller was pushed onto the stack
	} else if ([viewControllers indexOfObject:self] == NSNotFound) {
		[self.modelController.book abortLoading];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"navigateSegue"]) {
		PEFNavigationTableViewController *vc = (PEFNavigationTableViewController *)[[(UINavigationController *)segue.destinationViewController viewControllers] objectAtIndex:0];
		vc.delegate = self;
		
	} else 	if ([segue.identifier isEqualToString:@"navigateiPadSegue"]) {
		if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
			UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
			self.popover = popoverSegue.popoverController;
		}
		PEFNavigationTableViewController *vc = segue.destinationViewController;
		vc.delegate = self;
		
	}
}

#pragma mark - private
- (void)setDetailViewController:(UIViewController<SubstitutableDetailViewController> *)detail
{
	DetailViewManager *split = (DetailViewManager *)self.splitViewController.delegate;
	if ([split isKindOfClass:[DetailViewManager class]]) {
		split.detailViewController = detail;
	}
}


#pragma mark -
#pragma mark SubstitutableDetailViewController

// -------------------------------------------------------------------------------
//	setNavigationPaneBarButtonItem:
//  Custom implementation for the navigationPaneBarButtonItem setter.
//  In addition to updating the _navigationPaneBarButtonItem ivar, it
//  reconfigures the toolbar to either show or hide the
//  navigationPaneBarButtonItem.
// -------------------------------------------------------------------------------
- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
{
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
        if (navigationPaneBarButtonItem) {
            [self.toolbar setLeftBarButtonItem:navigationPaneBarButtonItem animated:NO];
        } else {
            [self.toolbar setLeftBarButtonItem:nil animated:NO];
		}
        _navigationPaneBarButtonItem = navigationPaneBarButtonItem;
    }
}

#pragma mark - ...

- (NSURL *)docDir
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (paths.count>0) {
		return [NSURL fileURLWithPath:(NSString *)[paths objectAtIndex:0]];
	} else {
		return nil;
	}
}

- (void)configureWithURL:(NSURL *)url table:(PEFBrailleTableFactory *)config {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"PEFLoadError" object:self.modelController.book];
	self.modelController = [[PEFModelController alloc]
								  initWithURL:url
								  volume:1
								  config:config.selectedTable];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseError:) name:@"PEFLoadError" object:self.modelController.book];

}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updatePageNumber:(NSUInteger)page
{
	PEFPage *p = [self.modelController.book pageAtIndex:page volume:0];
	self.pageNumber.title = [NSString stringWithFormat:@"%lu", (unsigned long)p.pageNumber];//page+1];
	float f = [self.modelController.book pageCountInVolume:0];
	f = page / (MAX(f, 2.0) - 1);
	self.pageSlider.value = f;
}

#pragma mark - UIPageViewController delegate methods

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
		NSUInteger v = [self currentIndex];
		[self updatePageNumber:v];
	}
}

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

#pragma mark - Turn page
- (NSUInteger)currentIndex
{
	PEFDataViewController *theCurrentViewController = [self.pageViewController.viewControllers   objectAtIndex:0];
    return [self.modelController indexOfViewController:theCurrentViewController];
}

- (void)gotoPage:(NSUInteger)pageToGoTo
{
	BOOL landscape = NO;
	//get current index of current page
	NSUInteger retreivedIndex = [self currentIndex];
	
    //get the page(s) to go to
    PEFDataViewController *targetPageViewController = [self.modelController viewControllerAtIndex:(pageToGoTo - 1) storyboard:self.storyboard];
	
	
    //put it(or them if in landscape view) in an array
    NSArray *theViewControllers = nil;
	if (landscape) {
		PEFDataViewController *secondPageViewController = [self.modelController viewControllerAtIndex:(pageToGoTo) storyboard:self.storyboard];
		theViewControllers = [NSArray arrayWithObjects:targetPageViewController, secondPageViewController, nil];
	} else {
		theViewControllers = [NSArray arrayWithObjects:targetPageViewController, nil];
	}
	
    //check which direction to animate page turn then turn page accordingly
    if (retreivedIndex < (pageToGoTo - 1) && retreivedIndex != (pageToGoTo - 1)){

        [self.pageViewController setViewControllers:theViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
	
    if (retreivedIndex > (pageToGoTo - 1) && retreivedIndex != (pageToGoTo - 1)){
        [self.pageViewController setViewControllers:theViewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
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

- (void)navigate:(id)sender
{
	[self performSegueWithIdentifier:@"navigateSegue" sender:self];
}

- (IBAction)itemSlider:(UISlider *)itemSlider withEvent:(UIEvent*)e;
{
    UITouch * touch = [e.allTouches anyObject];
	float f = round(([self.modelController.book pageCountInVolume:0]-1) * self.pageSlider.value) +1;
	int i = [[NSNumber numberWithFloat:f] intValue];
    if(touch.phase != UITouchPhaseMoved && touch.phase != UITouchPhaseBegan)
    {
		[self gotoPage:i];
    } else { //The user hasn't ended using the slider yet.

	}
//	self.pageNumber.title = [NSString stringWithFormat:@"%i", i];
	PEFPage *p = [self.modelController.book pageAtIndex:i-1 volume:0];
	self.pageNumber.title = [NSString stringWithFormat:@"%lu", (unsigned long)p.pageNumber];
}

#pragma mark - Private methods

- (void)hideTools:(BOOL)newStatus
{
	[self.navigationController setNavigationBarHidden:newStatus animated:YES];
	[self.navigationController setToolbarHidden:newStatus animated:YES];
}
#pragma mark - Gesture recognizer
- (void) didTap:(id)sender
{
	BOOL newStatus = !self.navigationController.isNavigationBarHidden;
	[self hideTools:newStatus];
}

#pragma mark - PEFNavigation
- (NSUInteger)countVolumes
{
	return self.modelController.book.volumes;
}
- (NSUInteger)countSectionsInVolume:(NSUInteger)volume
{
	return [(NSNumber *)[self.modelController.book.sectionsInVolume objectAtIndex:volume] intValue];
}
- (void)didCancelSelection
{
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didSelectSection:(NSUInteger)section volume:(NSUInteger)volume
{
	NSUInteger i = [self.modelController.book indexOfFirstPageInSection:section volume:volume];
	if (self.popover) {
		[self.popover dismissPopoverAnimated:YES];
		[self gotoPage:i];
		[self updatePageNumber:i-1];
		self.popover = nil;
	} else {
		[self dismissViewControllerAnimated:YES completion:^{
			//[self hideTools:YES];
			[self gotoPage:i];
			[self updatePageNumber:i-1];
		}];
	}
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}
#pragma mark - Notifications
- (void) parseError:(NSNotification *)notification
{
	UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Load errors" message:@"An error occured when loading the file." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[v show];
}
@end
