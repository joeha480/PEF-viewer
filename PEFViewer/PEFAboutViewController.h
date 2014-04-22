//
//  PEFAboutViewController.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-04-16.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PEFAboutViewController;

@protocol PEFAboutViewControllerDelegate <NSObject>
- (void)dismiss:(PEFAboutViewController *)vc;
@end

@interface PEFAboutViewController : UIViewController

@property IBOutlet UILabel *titleLabel;
@property IBOutlet UILabel *byLabel;
@property IBOutlet UITextView *contributeLabel;
@property id<PEFAboutViewControllerDelegate> delegate;

@end