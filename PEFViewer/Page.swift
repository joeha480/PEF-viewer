//
//  Page.swift
//  PEFViewer
//
//  Created by Joel Håkansson on 2015-06-27.
//  Copyright (c) 2015 Joel Håkansson. All rights reserved.
//

import Foundation

@objc(PEFPage)
class Page : NSObject {
	
	@objc let width, height: Int;
	@objc var data:Array<Row>;
	
	@objc var index, volumeNumber, sectionNumber, pageNumber: UInt;
	
	init (attributes atts:Attributes) {
		self.width = atts.width;
		self.height = atts.height;
		self.data = [Row]();
		//TODO: Could remove below and set variables as optional when Objective-C use is not needed anymore
		self.index = 0;
		self.volumeNumber = 0;
		self.sectionNumber = 0;
		self.pageNumber = 0;
	}
	
	func addRow(_ data:Row) {
		self.data.append(data);
	}
	
	func rows() -> Array<Row>? {
		return data;
	}
}
