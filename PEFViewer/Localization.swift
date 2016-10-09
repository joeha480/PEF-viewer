//
//  Localization.swift
//  PEFViewer
//
//  Created by Joel Håkansson on 2015-06-14.
//  Copyright (c) 2015 Joel Håkansson. All rights reserved.
//

import Foundation

@objc(PEFL10N)
class Localization : NSObject {
	
	static func filesTitle() -> String {
		return "Files"
	}
	static func filesFooter() -> String {
		return "%i files"
	}
	static func bookmarksTitle() -> String {
		return "Bookmarks"
	}
	static func tableSelectTitle() -> String {
		return "Select Table"
	}
}
