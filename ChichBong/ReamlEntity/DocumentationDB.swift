//
//  Documentation.swift
//  ChichBong
//
//  Created by autm on 23/12/2021.
//

import Foundation
import RealmSwift

class Documentation: Object {
    @objc dynamic var id = 0;
    @objc dynamic var name = "";
    @objc dynamic var content = "";
    @objc dynamic var dirfile = "";
    @objc dynamic var created = Date()
    @objc dynamic var type = 0
    
    override static func primaryKey() -> String? {
            return "id"
        }
}
