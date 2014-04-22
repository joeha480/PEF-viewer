//
//  PEFEmptyViewController.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-04-12.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import "PEFEmptyViewController.h"
#import "DetailViewManager.h"

@interface PEFEmptyViewController ()

@end

@implementation PEFEmptyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad
{
	//[self setSplitViewDelegate:self];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setDetailViewController:self];
	
	// -setNavigationPaneBarButtonItem may have been invoked when before the
    // interface was loaded.  This will occur when setNavigationPaneBarButtonItem
    // is called as part of DetailViewManager preparing this view controller
    // for presentation as this is before the view is unarchived from the NIB.
    // When viewidLoad is invoked, the interface is loaded and hooked up.
    // Check if we are supposed to be displaying a navigationPaneBarButtonItem
    // and if so, add it to the toolbar.
	/*
    if (_navigationPaneBarButtonItem) {
		[self.toolbar setLeftBarButtonItem:self.navigationPaneBarButtonItem animated:NO];
	}*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
#pragma mark - UISplitViewDelegate methods
-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
		 withBarButtonItem:(UIBarButtonItem *)barButtonItem
	  forPopoverController:(UIPopoverController *)pc
{
    //Grab a reference to the popover
    self.popover = pc;

    //Set the title of the bar button item
    barButtonItem.title = @"Monsters";
	
    //Set the bar button item as the Nav Bar's leftBarButtonItem
    [_navBarItem setLeftBarButtonItem:barButtonItem animated:YES];
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //Remove the barButtonItem.
    [_navBarItem setLeftBarButtonItem:nil animated:YES];
	
    //Nil out the pointer to the popover.
    _popover = nil;
}*/

@end
