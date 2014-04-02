//
//  PEFRootViewController.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-09-02.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PEFModelController;
@class PEFConfig;

@interface PEFRootViewController : UIViewController <UIPageViewControllerDelegate>
@property (strong, nonatomic) PEFModelController *modelController;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
