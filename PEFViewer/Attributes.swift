//
//  Attributes.swift
//  PEFViewer
//
//  Created by Joel Håkansson on 2015-06-14.
//  Copyright (c) 2015 Joel Håkansson. All rights reserved.
//

import Foundation

@objc(PEFAttributes)
class Attributes {
	@objc let width: Int
	@objc let height: Int
	@objc let duplex: Bool
	@objc let rowgap: Int

	init(width:Int, height: Int, duplex: Bool, rowgap:Int) {
		self.width = width;
		self.height = height;
		self.duplex = duplex;
		self.rowgap = rowgap;
	}
}