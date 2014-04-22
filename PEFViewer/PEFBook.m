//
//  PEFBook.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-12-03.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import "PEFBook.h"
#import "PEFAttributes.h"
#import "PEFRow.h"

static NSString *VOLUME_ADDED_NOTIFICATION = @"PEFVolumeAdded";
static NSString *LOAD_ERROR_NOTIFICATION = @"PEFLoadError";

static NSString *PEF_NS = @"http://www.daisy.org/ns/2008/pef";
static NSString *E_PEF = @"pef";
static NSString *E_VOLUME = @"volume";
static NSString *E_SECTION = @"section";
static NSString *E_PAGE = @"page";
static NSString *E_ROW = @"row";
static NSString *A_VERSION = @"version";
static NSString *A_ROWS = @"rows";
static NSString *A_COLS = @"cols";
static NSString *A_DUPLEX = @"duplex";
static NSString *A_ROWGAP = @"rowgap";

static NSString *DC_NS = @"http://purl.org/dc/elements/1.1/";
/*
static NSString *E_FORMAT = @"format";
static NSString *E_IDENTIFIER = @"identifier";
static NSString *E_TITLE = @"title";
static NSString *E_CREATOR = @"creator";
static NSString *E_SUBJECT = @"subject";
static NSString *E_DESCRIPTION = @"description";
static NSString *E_PUBLISHER = @"publisher";
static NSString *E_CONTRIBUTOR = @"contributor";
static NSString *E_DATE = @"date";
static NSString *E_TYPE = @"type";
static NSString *E_SOURCE = @"source";
static NSString *E_LANGUAGE = @"language";
static NSString *E_RELATION = @"relation";
static NSString *E_COVERAGE = @"coverage";
static NSString *E_RIGHTS = @"rights";*/

@interface PEFBook() <NSXMLParserDelegate>
@property (readonly, strong, nonatomic) NSMutableArray *pageData;
@property NSMutableDictionary *pageIndex;

@property BOOL inRow;
@property int cVolume;
@property int cSection;
@property int cPage;
@property int cRow;
@property int pageNumber;
@property PEFRow *cRowData;
@property PEFPage *cPageData;
@property PEFAttributes *cVsize;
@property PEFAttributes *cSsize;
@property NSString *text;
@property (readonly) NSXMLParser *parser;
@end

@implementation PEFBook
@synthesize pageIndex = _pageIndex;
@synthesize parser = _parser;
@synthesize sectionsInVolume = _sectionsInVolume;
@synthesize volumes = _volumes;
@synthesize loaded = _loaded;
@synthesize cVolume = _cVolume;
@synthesize cSection = _cSection;
@synthesize cPage = _cPage;
@synthesize cRow = _cRow;
@synthesize pageNumber = _pageNumber;
@synthesize inRow = _inRow;
@synthesize pageData = _pageData;
@synthesize cRowData = _cRowData;
@synthesize cPageData = _cPageData;
@synthesize url = _url;
@synthesize cVsize = _cVsize;
@synthesize cSsize = _cSsize;
@synthesize text = _text;
@synthesize metadata = _metadata;
@synthesize errors = _errors;
@synthesize warnings = _warnings;

- (id)initWithURL:(NSURL *)url
{
	self = [super init];
	if (self) {
		_pageIndex = [[NSMutableDictionary alloc] initWithCapacity:10];
		_loaded = NO;
		_url = url;
		// Create the data model.
		_cVolume = 0;
		_cSection = 0;
		_cPage = -1;
		_pageNumber = 1;
		_inRow = false;
		_sectionsInVolume = [[NSMutableArray alloc] initWithCapacity:10];
		_metadata = [[NSMutableDictionary alloc] initWithCapacity:10];
		_errors = [[NSMutableArray alloc] initWithCapacity:10];
		_warnings = [[NSMutableArray alloc] initWithCapacity:10];
		
		_parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		_parser.delegate = self;
		_parser.shouldProcessNamespaces = YES;
		_pageData = [[NSMutableArray alloc] initWithCapacity:10];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
			if ([_parser parse]) {
				_volumes = self.cVolume;
				_loaded = YES;
			}
		});
	}
	return self;
}

#pragma mark - Public methods
- (NSUInteger)sectionsInVolume:(NSUInteger)volume
{
	return 0;
}
- (NSUInteger)pageCountInVolume:(NSUInteger)volume
{
	return self.pageData.count;
}

- (PEFPage *)pageAtIndex:(NSUInteger)index volume:(NSUInteger)volume
{
	return self.pageData[index];
}
- (NSUInteger)indexOfFirstPageInSection:(NSUInteger)section volume:(NSUInteger)volume
{
	NSString *keyFind = [NSString stringWithFormat:@"%lu_%lu", (unsigned long)volume, (unsigned long)section];
	NSNumber *n = [self.pageIndex objectForKey:keyFind];
	if (n) {
		return [n intValue];
	} else {
		return 1;
	}
}
- (void)abortLoading
{
	[self.parser abortParsing];
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	//Slow down for debugging
	//[NSThread sleepForTimeInterval:0.005f];
	if ([namespaceURI isEqualToString:PEF_NS]) {
		if ([elementName isEqualToString:E_ROW]) {
			self.inRow = YES;
			self.cRow++;
			self.cRowData = [[PEFRow alloc] init];
			PEFAttributes *atts = [self getRowgap:attributeDict defaults:self.cSsize];
			self.cRowData.data = @"";
			self.cRowData.rowgap = atts.rowgap;
		} else if ([elementName isEqualToString:E_PAGE]) {
			self.cPage++;
			PEFPage *n = [[PEFPage alloc] initWithAttributes:[self getRowgap:attributeDict defaults:self.cSsize]];
			n.index = self.cPage;
			n.pageNumber = self.pageNumber;
			n.volumeNumber = self.cVolume;
			n.sectionNumber = self.cSection;
			self.cPageData = n;
			self.pageNumber = self.pageNumber + (self.cSsize.duplex?1:2);
		} else if ([elementName isEqualToString:E_SECTION]) {
			self.cSection++;
														//+1 for one based, +1 for next value
			[self.pageIndex setObject:[NSNumber numberWithInt:self.cPage+1+1] forKey:[NSString stringWithFormat:@"%i_%i", self.cVolume, self.cSection]];
			self.cSsize = [self getAttributes:attributeDict defaults:self.cVsize];
			[self printAttributes:self.cVsize element:E_SECTION];
			//make sure page number is odd
			if (self.pageNumber % 2 == 0) {
				self.pageNumber ++;
			}
		} else if ([elementName isEqualToString:E_VOLUME]) {
			self.cVolume++;
			self.cSection = 0;
			self.cVsize = [self getAttributes:attributeDict defaults:nil];
			[self printAttributes:self.cVsize element:E_VOLUME];
		} else if ([elementName isEqualToString:E_PEF]) {
			NSString *version = [attributeDict objectForKey:A_VERSION];
			if (![version isEqualToString:@"2008-1"]) {
				[self.errors
				 addObject:[NSString stringWithFormat:@"Unsupported PEF-version: %@", version]];
			}
		}
	} else if ([namespaceURI isEqualToString:DC_NS]) {
		self.text = @"";
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([namespaceURI isEqualToString:PEF_NS]) {
		if ([elementName isEqualToString:E_ROW]) {
			[self.cPageData addRow:self.cRowData];
			self.inRow = NO;
		} else if ([elementName isEqualToString:E_PAGE]) {
			[self.pageData addObject:self.cPageData];
			self.cPageData = nil;
		} else if ([elementName isEqualToString:E_SECTION]) {
			self.cSsize = nil;
		} else if ([elementName isEqualToString:E_VOLUME]) {
			[self.sectionsInVolume addObject:[NSNumber numberWithInt:self.cSection]];
			self.cVsize = nil;
			_volumes = self.cVolume;
			dispatch_async(dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:VOLUME_ADDED_NOTIFICATION object:self userInfo:nil];
			});
		} else if ([elementName isEqualToString:E_PEF]) {
			if (self.errors.count>0) {
				[self reportFatalError];
			}
		}
	} else if ([namespaceURI isEqualToString:DC_NS]) {
		NSMutableArray *vals = [self.metadata objectForKey:elementName];
		if (!vals) {
			vals = [[NSMutableArray alloc] initWithCapacity:5];
			[self.metadata setObject:vals forKey:elementName];
		}
		[vals addObject:self.text];
		self.text = @"";
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (self.inRow) {
		self.cRowData.data = [self.cRowData.data stringByAppendingString:string];
	} else {
		self.text = [self.text stringByAppendingString:string];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSLog(@"Parser error: %@", parseError);
	[self appendMsg:parseError.localizedDescription error:YES];
	[self reportFatalError];
}

#pragma mark - Private methods
- (void)printAttributes:(PEFAttributes *)atts element:(NSString *)element
{
	NSLog(@"%@: %i x %i (%@, rowgap: %i)", element, atts.width, atts.height, (atts.duplex?@"duplex":@"simplex"), atts.rowgap);
}

- (PEFAttributes *)getAttributes:(NSDictionary *)attributeDict defaults:(PEFAttributes *)defaults
{
	NSString *rs = [attributeDict objectForKey:A_ROWS];
	NSString *cs = [attributeDict objectForKey:A_COLS];
	NSString *ds = [attributeDict objectForKey:A_DUPLEX];
	NSString *rgs = [attributeDict objectForKey:A_ROWGAP];
	int ri = 0, ci = 0, rgi = 0;
	BOOL db = NO;
	
	if (rs) {
		ri = rs.intValue;
	}
	if (ri == 0) {
		if (!defaults) {
			[self reportAttributeMissing:A_ROWS error:YES];
		} else {
			ri = defaults.height;
		}
	}
	if (cs) {
		ci = cs.intValue;
	}
	if (ci == 0) {
		if (!defaults) {
			[self reportAttributeMissing: A_COLS error:YES];
		} else {
			ci = defaults.width;
		}
	}
	if (ds) {
		db = ds.boolValue;
	} else {
		if (!defaults) {
			[self reportAttributeMissing: A_DUPLEX error:YES];
		} else {
			db = defaults.duplex;
		}
	}
	if (rgs) {
		rgi = rgs.intValue;
	} else {
		if (!defaults) {
			[self reportAttributeMissing:A_ROWGAP error:YES];
		} else {
			rgi = defaults.rowgap;
		}
	}
	
	return [[PEFAttributes alloc] initWitWidth:ci height:ri duplex:db rowgap:rgi];
}

- (PEFAttributes *)getRowgap:(NSDictionary *)attributeDict defaults:(PEFAttributes *)defaults
{
	int rgi = 0;
	NSString *rgs = [attributeDict objectForKey:A_ROWGAP];
	if (rgs) {
		rgi = rgs.intValue;
	} else {
		if (!defaults) {
			[self reportAttributeMissing:A_ROWGAP error:YES];
		} else {
			rgi = defaults.rowgap;
		}
	}
	return [[PEFAttributes alloc] initWitWidth:defaults.width
										height:defaults.height
										duplex:defaults.duplex
										rowgap:rgi];
}

- (void)reportAttributeMissing:(NSString *)attribute error:(BOOL)error
{
	NSString *msg = [NSString stringWithFormat:@"Invalid or missing attribute %@ on volume element #%i.", attribute, self.cVolume];
	[self appendMsg:msg error:error];
}

- (void)appendMsg:(NSString *)msg error:(BOOL)error {
	if (error) {
		[self.errors addObject:msg];
	} else {
		[self.warnings addObject:msg];
	}
}

- (void)reportFatalError
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:self.errors, @"errors", nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:LOAD_ERROR_NOTIFICATION object:self userInfo:info];
	});
}


@end
