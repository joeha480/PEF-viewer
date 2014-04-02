//
//  PEFDataViewController.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-09-02.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import "PEFDataViewController.h"
#import "PEFPageView.h"
#import "PEFPage.h"
#import "PEFModelController.h"
#import "PEFBrailleTable.h"

@interface PEFDataViewController ()

@end

@implementation PEFDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	[self.view addGestureRecognizer:tap];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"PEF-update" object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	//[NSString stringWithFormat:@"Sida %i", self.cPage+1]
    self.dataLabel.text = [self.delegate.dataObject description];
	self.pageView.translation = self.delegate.controller.table.table; // @" a1b'k2l`cif/msp\"e3h9o6r~djg>ntq,*5<-u8v.%{$+x!&;:4|0z7(_?w}#y)=";//self.delegate.config.selectedTable.table;
	[self.pageView setTranslating:self.delegate.controller.isTranslating];
	self.pageView.dataSource = self.delegate.dataObject;
	;
	
	self.pageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	self.pageView.transform = [self getTransformForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[UIView animateWithDuration:duration animations:^ {
		self.pageView.transform = [self getTransformForOrientation:toInterfaceOrientation];
	}];
}

#pragma mark - private
- (CGAffineTransform)getTransformForOrientation:(UIInterfaceOrientation)orientation
{
	CGSize s = [UIScreen mainScreen].bounds.size;
	float scale = 0.94*MIN(s.width / self.pageView.originalSize.width, s.height / self.pageView.originalSize.height) ;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		scale = scale * (s.width/s.height);
		NSLog(@"%f",scale);
		return CGAffineTransformMakeScale(scale, scale);
	} else {
		return CGAffineTransformMakeScale(scale, scale);
	}
}

#pragma mark - Gesture recognizer
- (void) didTap:(id)sender
{
	BOOL newStatus = !self.navigationController.isNavigationBarHidden;
	[self.navigationController setNavigationBarHidden:newStatus animated:YES];
	[self.navigationController setToolbarHidden:newStatus animated:YES];
}

#pragma mark - Notifications
- (void) notification:(NSNotification *)notification
{
	NSNumber *n = [[notification userInfo] objectForKey:@"translating"];
	[self.pageView setTranslating:[n boolValue]];
}

@end
