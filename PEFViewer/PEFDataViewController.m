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
    self.dataLabel.text = [NSString stringWithFormat:@"Volume %lu, Section %lu | Page %lu", (unsigned long)self.delegate.dataObject.volumeNumber, (unsigned long)self.delegate.dataObject.sectionNumber, (unsigned long)self.delegate.dataObject.pageNumber];
	self.pageView.translation = self.delegate.controller.table.table; // @" a1b'k2l`cif/msp\"e3h9o6r~djg>ntq,*5<-u8v.%{$+x!&;:4|0z7(_?w}#y)=";//self.delegate.config.selectedTable.table;
	[self.pageView setTranslating:self.delegate.controller.isTranslating];
	self.pageView.dataSource = self.delegate.dataObject;
	;
/*
	self.pageView.page.transform = [self getTransformForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
	self.pageView.page.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	CGRect r = self.pageView.page.frame;
	r.origin = CGPointMake(r.origin.x, 0);
	[self.pageView.page setFrame:r];*/
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
/*
	[UIView animateWithDuration:duration animations:^ {
		//self.pageView.page.transform = [self getTransformForOrientation:toInterfaceOrientation];
		self.pageView.page.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
		CGRect r = self.pageView.page.frame;
		r.origin = CGPointMake(r.origin.x, 0);
		[self.pageView.page setFrame:r];
	}];*/
}
/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	self.pageView.page.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	CGRect r = self.pageView.page.frame;
	r.origin = CGPointMake(r.origin.x, 0);
	[self.pageView.page setFrame:r];

}*/

#pragma mark - private
/*
- (CGAffineTransform)getTransformForOrientation:(UIInterfaceOrientation)orientation
{
	CGSize s = [UIScreen mainScreen].bounds.size;
	float scale = 0.90*MIN(s.width / self.pageView.originalSize.width, s.height / self.pageView.originalSize.height) ;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		scale = scale * (s.width/s.height);
		NSLog(@"%f",scale);
		return CGAffineTransformMakeScale(scale, scale);
	} else {
		NSLog(@"%f",scale);
		return CGAffineTransformMakeScale(scale, scale);
	}
}
*/


#pragma mark - Notifications
- (void) notification:(NSNotification *)notification
{
	NSNumber *n = [[notification userInfo] objectForKey:@"translating"];
	[self.pageView setTranslating:[n boolValue]];
}

@end
