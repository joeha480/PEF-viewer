//
//  PEFEmptyViewController.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-04-12.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewManager.h"

@interface PEFEmptyViewController : UIViewController<SubstitutableDetailViewController>

@property (nonatomic, retain) IBOutlet UINavigationItem *toolbar;

/// SubstitutableDetailViewController
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;

/*
@property (nonatomic, weak) IBOutlet UINavigationItem *navBarItem;
@property (nonatomic, strong) UIPopoverController *popover;
*/
@end
