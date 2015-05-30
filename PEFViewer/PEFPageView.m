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
#import "PEFBrailleTable.h"

@interface PEFPageView()
@property (nonatomic) BOOL translating;
@property (readonly) UIFont *font;

@end

@implementation PEFPageView
@synthesize dataSource = _dataSource;
@synthesize translation = _translation;
@synthesize translating = _translating;
@synthesize font = _font;
@synthesize originalSize = _originalSize;

//int fs = 12;
int margin = 20;
float fontRatio = 13.0/17.0;
int rh = 40;
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableChanged:) name:@"PEFTableChanged" object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
	self.page.transform = [self getTransformForBounds:self.bounds.size];
	self.page.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	CGRect r = self.page.frame;
	r.origin = CGPointMake(r.origin.x, 0);
	[self.page setFrame:r];
}
#pragma mark - Public API
- (void)setTranslating:(BOOL)value
{
	if (_translating!=value) {
		[self updateTranslation:value];
	}
}

#pragma mark - Private
- (void)updateTranslation:(BOOL)value
{
	int i = 0;
	PEFRow *s;
	for (UILabel *v in self.page.subviews) {
		//protect against subviews that aren't labels
		//it's a rather weak way of ensuring we have the rows,
		//but it will do for now.
		if ([v isKindOfClass:[UILabel class]]) {
			s = [self.dataSource.rows objectAtIndex:i];
			if (value) {
				v.text = [self translate:s.data];
			} else {
				v.text = s.data;
			}
			v.font = self.font;
			i++;
		}
	}
	_translating = value;
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
	rh = MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) / self.dataSource.height;
	_font = [UIFont fontWithName:@"Courier New" size:rh * fontRatio];
	// 1pt	=	1 inch		25.4 mm		 px
	//			72 			 inch		0.15875	mm
	//NSLog(@"Cap height: %f", (((_font.capHeight / 72) * 25.4) / 0.15875));

	NSString *testString = [@"" stringByPaddingToLength:self.dataSource.width withString:@"\u2800" startingAtIndex:0];
	CGSize ex = [testString sizeWithAttributes:[[NSDictionary alloc] initWithObjects:@[self.font] forKeys:@[NSFontAttributeName]]];
	
	rw = ceil(ex.width) + margin*2;
	h = self.dataSource.height*rh;
	_originalSize = CGSizeMake(rw, h);
	//SLog(@"pw:%f w:%i h:%i", self.bounds.size.width, rw, h);

	self.page = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rw, h)];
	[self.page setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	[self.page setContentMode:UIViewContentModeCenter];
/*	self.page.backgroundColor = [UIColor grayColor];
	[self.page setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.page setContentMode:UIViewContentModeScaleAspectFit];*/
	UIView *binder;
	if (self.dataSource.pageNumber % 2 == 1) {
		binder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, h)];
	} else {
		binder = [[UIView alloc] initWithFrame:CGRectMake(rw-5, 0, 5, h)];
	}
	binder.backgroundColor = [UIColor lightGrayColor];
	[self.page addSubview:binder];

	int y = 0;
	UILabel *label;
	self.page.backgroundColor = [UIColor whiteColor];
	
	self.page.layer.borderColor = [UIColor blackColor].CGColor;
	self.page.layer.borderWidth = 1.0f;
	
	self.page.layer.masksToBounds = NO;
	self.page.layer.shadowOffset = CGSizeMake(5, 5);
	self.page.layer.shadowRadius = 3;
	self.page.layer.shadowOpacity = 0.3;

	for (PEFRow *s in dataSource.rows) {
		label = [[UILabel alloc] initWithFrame:CGRectMake(margin, y, rw, rh)];
		label.userInteractionEnabled  = YES;

		//[label setAdjustsFontSizeToFitWidth:YES];
		label.font = self.font;
		label.minimumScaleFactor = 2;
		//[label setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		if (_translating) {
			label.text = [self translate:s.data];
		} else {
			label.text = s.data;
		}

		[self.page addSubview:label];
		y += rh * (1+ s.rowgap / 4.0f);
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
#pragma mark - private
- (CGAffineTransform)getTransformForBounds:(CGSize)s
{
	float ws = s.width / self.originalSize.width;
	float hs = s.height / self.originalSize.height;
	float scale = 0.98*MIN(ws, hs);
	return CGAffineTransformMakeScale(scale, scale);
}

#pragma mark - Notifications
- (void) tableChanged:(NSNotification *)notification
{
	PEFBrailleTable *n = [[notification userInfo] objectForKey:@"table"];
	self.translation = n.table;
	if (_translating) {
		[self updateTranslation:_translating];
	}
}
@end
