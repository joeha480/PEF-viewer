//
//  PEFBook.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-12-03.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import "PEFBook.h"
#import "PEFSize.h"
#import "PEFRow.h"

@interface PEFBook() <NSXMLParserDelegate>
@property (readonly, strong, nonatomic) NSMutableArray *pageData;

@property BOOL inRow;
@property int cVolume;
@property int cPage;
@property int cRow;
@property PEFRow *cRowData;
@property PEFSize *cVsize;
@property PEFSize *cSsize;

@end

@implementation PEFBook

@synthesize dcCreator = _dcCreator;
@synthesize dcTitle = _dcTitle;
@synthesize dcIdentifier = _dcIdentifier;
@synthesize dcDate = _dcDate;
@synthesize dcDescription = _dcDescription;

@synthesize cVolume = _cVolume;
@synthesize cPage = _cPage;
@synthesize cRow = _cRow;
@synthesize inRow = _inRow;
@synthesize pageData = _pageData;
@synthesize cRowData = _cRowData;
@synthesize url = _url;
@synthesize cVsize = _cVsize;
@synthesize cSsize = _cSsize;

- (id)initWithURL:(NSURL *)url
{
	self = [super init];
	if (self) {
		_url = url;
		// Create the data model.
		_cVolume = 0;
		_cPage = -1;
		_inRow = false;
		
		NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
		parser.delegate = self;
		parser.shouldProcessNamespaces = YES;
		_pageData = [[NSMutableArray alloc] initWithCapacity:10];
		[parser parse];
	}
	return self;
}

#pragma mark - Public methods
- (NSUInteger)pageCountInVolume:(NSUInteger)volume
{
	return self.pageData.count;
}

- (PEFPage *)pageAtIndex:(NSUInteger)index volume:(NSUInteger)volume
{
	return self.pageData[index];
}


#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([namespaceURI isEqualToString:@"http://www.daisy.org/ns/2008/pef"]) {
		if ([elementName isEqualToString:@"row"]) {
			self.inRow = YES;
			self.cRow++;
			self.cRowData = [[PEFRow alloc] init];
			self.cRowData.data = @"";
		} else if ([elementName isEqualToString:@"page"]) {
			self.cPage++;
			int w = self.cVsize.width;
			int h = self.cVsize.height;
			if (self.cSsize) {
				w = self.cSsize.width;
				h = self.cSsize.height;
			}
			NSLog(@"Size: %i x %i", w, h);
			PEFPage *n = [[PEFPage alloc] initWithWidth:w height:h];
			n.index = self.cPage;
			[self.pageData addObject:n];
		} else if ([elementName isEqualToString:@"section"]) {
			NSString *rs = [attributeDict objectForKey:@"rows"];
			NSString *cs = [attributeDict objectForKey:@"cols"];
			if (rs && cs) {
				self.cSsize = [[PEFSize alloc] initWitWidth:cs.intValue height:rs.intValue];
			}
		} else if ([elementName isEqualToString:@"volume"]) {
			self.cVolume++;
			NSString *rs = [attributeDict objectForKey:@"rows"];
			NSString *cs = [attributeDict objectForKey:@"cols"];
			if (rs && cs) {
				self.cVsize = [[PEFSize alloc] initWitWidth:cs.intValue height:rs.intValue];
			}
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([namespaceURI isEqualToString:@"http://www.daisy.org/ns/2008/pef"]) {
		if ([elementName isEqualToString:@"row"]) {
			PEFPage *r = [self.pageData lastObject];
			[r addRow:self.cRowData];
			self.inRow = NO;
		} else if ([elementName isEqualToString:@"section"]) {
			self.cSsize = nil;
		} else if ([elementName isEqualToString:@"volume"]) {
			self.cVsize = nil;
		}
	} else if ([namespaceURI isEqualToString:@"http://purl.org/dc/elements/1.1/"]) {
		if ([elementName isEqualToString:@"creator"]) {
			NSLog(@"creator");
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (self.inRow) {
		self.cRowData.data = [self.cRowData.data stringByAppendingString:string];
	}
}

@end
