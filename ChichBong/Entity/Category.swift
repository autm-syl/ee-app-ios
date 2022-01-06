//
//  Category.swift
//  ChichBong
//
//  Created by autm on 16/12/2021.
//

import ObjectMapper

class CategoryResult: Mappable {
    var categories:[Category] = []
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         categories <- map["Data"]
        message <- map["Message"]
    }
}

class Category: Mappable {
    var id = 0;
    var parent = 0;
    var name = "";
    var description = "";
    var content = "";
    var docid = 0;
    var created_at = "";
    var updated_at = "";
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         id <- map["Id"];
         parent <- map["Parent"];
         name <- map["Name"];
         description <- map["Description"];
         content <- map["Content"];
         docid <- map["Docid"];
         created_at <- map["Created_at"];
         updated_at <- map["Updated_at"];
    }
}

import UIKit

class CategoryTreeData {
    var id = 0;
    var name = "";
    var description = "";
    var content = "";
    var docid = 0;
    var created_at = "";
    var updated_at = "";
    var isHtml = false;
    
    var children : [CategoryTreeData] = []
    
    init(id:Int, name : String, description : String, content : String, docid : Int, created_at : String, updated_at : String, children: [CategoryTreeData]) {
        self.id = id
        self.name = name
        self.description = name
        self.content = content
        self.docid = docid
        self.created_at = created_at
        self.updated_at = updated_at
        self.children = children
    }
    
    convenience init(id:Int, name : String, description : String, content : String, docid : Int, created_at : String, updated_at : String) {
        self.init(id: id, name: name, description: description, content: content, docid : docid, created_at: created_at, updated_at:updated_at, children: [CategoryTreeData]())
    }
    
    func addChild(_ child : CategoryTreeData) {
        self.children.append(child)
    }
    
    func removeChild(_ child : CategoryTreeData) {
        self.children = self.children.filter( {$0 !== child})
    }
}
