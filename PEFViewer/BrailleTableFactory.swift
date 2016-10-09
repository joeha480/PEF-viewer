//
//  BrailleTableFactory.swift
//  PEFViewer
//
//  Created by Joel Håkansson on 2015-06-28.
//  Copyright (c) 2015 Joel Håkansson. All rights reserved.
//

import Foundation

@objc(PEFBrailleTableFactory)
class BrailleTableFactory : NSObject {
	static let TABLE_INDEX_KEY = "TABLE_INDEX_KEY";
	@objc var tables:Array<BrailleTable>;
	@objc var selectedTable:BrailleTable?;
	@objc var selectedTableIndex:Int{
		didSet {
			updateSelectedTable();
		}
	}

	override init() {
		self.tables=[BrailleTable]();
		tables.append(BrailleTable(name: "English (lower case)", description: "", table: " a1b'k2l`cif/msp\"e3h9o6r~djg>ntq,*5<-u8v.%{$+x!&;:4|0z7(_?w}#y)="));
		tables.append(BrailleTable(name: "Danish", description: "", table: " a,b.k;l'cif/msp`e:h*o!r~djgæntq@å?ê-u(v\\îøë§xèç^û_ü)z\"à|ôwï#yùé"));
		tables.append(BrailleTable(name: "German", description: "", table: " a,b.k;l\"cif|msp!e:h*o+r>djg`ntq'1?2-u(v$3960x~&<5/8)z={_4w7#y}%"));
		tables.append(BrailleTable(name: "Swedish (CX)", description: "Matches the Swedish representation in CX", table: " a,b.k;l^cif/msp'e:h*o!r~djgäntq_å?ê-u(v@îöë§xèç\"û+ü)z=à|ôwï#yùé"));
		self.selectedTable = nil;
		//returns 0 if value was not stored
		self.selectedTableIndex = UserDefaults.standard.integer(forKey: BrailleTableFactory.TABLE_INDEX_KEY);
		//didSet not called in init. See https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html#//apple_ref/doc/uid/TP40014097-CH14-ID254
		super.init();
		updateSelectedTable();
	}
	
	fileprivate func updateSelectedTable() {
		let si = self.selectedTableIndex % self.tables.count;
		selectedTable = tables[si];
		let defaults = UserDefaults.standard;
		defaults.set(si, forKey: BrailleTableFactory.TABLE_INDEX_KEY);
		defaults.synchronize();
	}

}
