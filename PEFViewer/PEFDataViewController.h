//
//  PEFDataViewController.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-09-02.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PEFPage;
@class PEFPageView;
@class PEFModelController;

@protocol PEFDataViewControllerDelegate <NSObject>

@property PEFPage *dataObject;
@property (weak) PEFModelController *controller;

@end
@interface PEFDataViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak) IBOutlet PEFPageView *pageView;
@property (strong) id<PEFDataViewControllerDelegate> delegate;
/*
@property (strong, nonatomic) PEFPage *dataObject;
@property (nonatomic, getter=isTranslating) BOOL translating;
*/
@end
