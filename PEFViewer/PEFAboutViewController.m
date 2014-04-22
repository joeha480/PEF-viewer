//
//  PEFAboutViewController.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-04-16.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import "PEFAboutViewController.h"

@interface PEFAboutViewController ()
@property (readonly) UIBarButtonItem *cancelButton;
@end

@implementation PEFAboutViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.titleLabel.text = @"PEF Viewer";
	self.byLabel.text = @"by Joel Håkansson";
	self.contributeLabel.text = @"Do you want to contribute?\n\nCheck out the project on GitHub:\nhttps://github.com/joeha480/PEF-viewer";
	
	_cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancel:)];
	self.navigationItem.rightBarButtonItem = self.cancelButton;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Selector
- (void)cancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
