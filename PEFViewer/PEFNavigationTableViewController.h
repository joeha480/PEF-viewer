//
//  PEFNavigationTableViewController.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-04-12.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEFNavigation.h"

@interface PEFNavigationTableViewController : UITableViewController

@property id<PEFNavigation> delegate;

@end
