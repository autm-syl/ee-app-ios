//
//  Documentation.swift
//  ChichBong
//
//  Created by autm on 22/12/2021.
//

import Foundation

import ObjectMapper

class DocumentationResult: Mappable {
    var Data:Documentations?
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        Data <- map["Data"]
        message <- map["Message"]
    }
}

class Documentations: Mappable {
    var Data:[DocumentObj] = []
    var total:Int = 0
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         Data <- map["data"]
         total <- map["total"]
    }
}

class DocumentObj: Mappable {
    var Id:Int = 0
    var Name:String = ""
    var Sub_name:String = ""
    var Category_id:String = ""
    var Link_doc:String = ""
    var Doc_type:Int = 0
    var Content:String = ""
    var Dir_file:String?
    var Created_by:Int = 0
    var Created_by_name:String?
    var Attachment:String = ""
    var Status:String?
    var Created_at:String = ""
    var Updated_at:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         Id <- map["Id"]
         Name <- map["Name"]
         Sub_name <- map["Sub_name"]
         Category_id <- map["Category_id"]
         Link_doc <- map["Link_doc"]
         Doc_type <- map["Doc_type"]
         Content <- map["Content"]
         Dir_file <- map["Dir_file"]
         Created_by <- map["Created_by"]
         Created_by_name <- map["Created_by_name"]
         Attachment <- map["Attachment"]
         Status <- map["Status"]
         Created_at <- map["Created_at"]
         Updated_at <- map["Updated_at"]
         
         Created_at = Created_at.replacingOccurrences(of: "T", with: " ")
         Created_at = Created_at.replacingOccurrences(of: "Z", with: "")
         
         Updated_at = Updated_at.replacingOccurrences(of: "T", with: " ")
         Updated_at = Updated_at.replacingOccurrences(of: "Z", with: "")
    }
}

