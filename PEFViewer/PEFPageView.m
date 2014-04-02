//
//  PEFPageView.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-01-02.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import "PEFPageView.h"
#import "PEFPage.h"
#import "PEFRow.h"

@interface PEFPageView()
@property (nonatomic) BOOL translating;
@property (strong) UIView *page;
@property (readonly) UIFont *font;

@end

@implementation PEFPageView
@synthesize dataSource = _dataSource;
@synthesize translation = _translation;
@synthesize translating = _translating;
@synthesize font = _font;
@synthesize originalSize = _originalSize;

//int fs = 12;
int rh = 20;
int rw;
int h;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (void)setup
{
	_font = [UIFont fontWithName:@"Courier New" size:13];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - Public API
- (void)setTranslating:(BOOL)value
{
	if (value ) {
		
	} else {
		
	}
	if (_translating!=value) {
		int i = 0;
		PEFRow *s;
		for (UILabel *v in self.page.subviews) {
			s = [self.dataSource.rows objectAtIndex:i];
			if (value) {
				v.text = [self translate:s.data];
			} else {
				v.text = s.data;
			}
			v.font = self.font;
			i++;
		}
		_translating = value;
	}
}

#pragma mark - Getters and setters
- (void)setDataSource:(PEFPage *)dataSource
{
	if (!dataSource) {
		NSLog(@"NO DATA");
	}
	_dataSource = dataSource;
	for (UIView *v in self.subviews) {
		[v removeFromSuperview];
	}

	NSString *testString = [@"" stringByPaddingToLength:self.dataSource.width withString:@"\u2800" startingAtIndex:0];
	CGSize ex = [testString sizeWithAttributes:[[NSDictionary alloc] initWithObjects:@[self.font] forKeys:@[NSFontAttributeName]]];
	
	rw = ceil(ex.width);
	h = self.dataSource.height*rh;
	_originalSize = CGSizeMake(rw, h);

	self.page = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rw, h)];
	[self.page setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	[self.page setContentMode:UIViewContentModeCenter];
/*	self.page.backgroundColor = [UIColor grayColor];
	[self.page setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.page setContentMode:UIViewContentModeScaleAspectFit];*/

	int y = 0;
	UILabel *label;

	for (PEFRow *s in dataSource.rows) {
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, rw, rh)];
		//[label setAdjustsFontSizeToFitWidth:YES];
		label.font = self.font;
		label.backgroundColor = [UIColor greenColor];
		label.minimumScaleFactor = 2;
		//[label setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		if (_translating) {
			label.text = [self translate:s.data];
		} else {
			label.text = s.data;
		}

		[self.page addSubview:label];
		y += rh;
	}
	[self addSubview:self.page];
}

#pragma mark - Private methods
- (NSString *)translate:(NSString *)input
{
	if (self.translation) {
		NSString *ret = @"";
		unichar c;
		for(int i = 0; i < [input length]; ++i) {
			c = [input characterAtIndex:i];
			int x = c-0x2800;
			ret = [NSString stringWithFormat:@"%@%C", ret,[self.translation characterAtIndex:x]];
		}
		return ret;
	} else {
		return input;
	}
}
@end
