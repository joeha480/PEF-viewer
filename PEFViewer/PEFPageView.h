//
//  PEFPageView.h
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-01-02.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PEFPage;

@interface PEFPageView : UIView

@property (weak, nonatomic) PEFPage *dataSource;
@property (readonly) CGSize originalSize;
@property NSString *translation;
- (void)setTranslating:(BOOL)value;
@end
