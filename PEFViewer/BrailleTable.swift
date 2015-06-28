//
//  BrailleTable.swift
//  PEFViewer
//
//  Created by Joel Håkansson on 2015-06-27.
//  Copyright (c) 2015 Joel Håkansson. All rights reserved.
//

import Foundation

@objc(PEFBrailleTable)
class BrailleTable {
	@objc let tName, tDescription, table:String;
	
	init(name:String, description desc:String, table:String) {
		self.tName = name;
		self.tDescription = desc;
		self.table = table;
	}
}