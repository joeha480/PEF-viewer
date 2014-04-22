//
//  PEFRootViewController.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-09-02.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewManager.h"
@class PEFModelController;
@class PEFBrailleTableFactory;

@protocol PEFRootViewControllerDelegate <NSObject>
- (void)configureWithURL:(NSURL *)url table:(PEFBrailleTableFactory *)config;
@end

@interface PEFRootViewController : UIViewController <PEFRootViewControllerDelegate, SubstitutableDetailViewController, UIPageViewControllerDelegate>
- (void)gotoPage:(NSUInteger)pageToGoTo;

@property (nonatomic, retain) IBOutlet UINavigationItem *toolbar;

/// SubstitutableDetailViewController
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;

@property (strong, nonatomic) PEFModelController *modelController;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property IBOutlet UIBarButtonItem *navigate;
@property IBOutlet UIBarButtonItem *sliderButton;
@property IBOutlet UIBarButtonItem *pageNumber;

- (IBAction)toggleTranslation:(id)sender;

@end
