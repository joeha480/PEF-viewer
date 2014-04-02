//
//  PEFTableSelectViewController.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-02-28.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PEFTableSelectViewController;
@class PEFConfig;

@protocol PEFTableSelectViewControllerDelegate <NSObject>

@property (readonly) PEFConfig *config;
- (void)dismiss:(PEFTableSelectViewController*)viewController;

@end

@interface PEFTableSelectViewController : UITableViewController
@property id<PEFTableSelectViewControllerDelegate> delegate;
@end
