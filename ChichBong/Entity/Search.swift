//
//  Search.swift
//  ChichBong
//
//  Created by autm on 11/01/2022.
//


import ObjectMapper

class SearchResult: Mappable {
    var Data:[SearchDocumentationsObj] = []
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        Data <- map["Data"]
        message <- map["Message"]
    }
}


class SearchDocumentationsObj: Mappable {
    var Id:Int = 0
    var Name:String = ""
    var Sub_name:String = ""
    var Category_id:String = ""
    var Link_doc:String = ""
    var Doc_type:Int = 0
    var Content:String = ""
    var Dir_file:String?
    var Created_by:Int = 0
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


