//
//  News.swift
//  ChichBong
//
//  Created by autm on 06/01/2022.
//


import ObjectMapper

class NewsResult: Mappable {
    var news:[NewsObj] = []
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         news <- map["Data"]
        message <- map["Message"]
    }
}

class NewsObj: Mappable {
    var id = 0;
    var category_name = "";
    var content = "";
    var ordinal = 0;
    var thumbnail = "";
    var title = "";
    var created_at = "";
    var updated_at = "";
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         id <- map["Id"];
         category_name <- map["Category_name"];
         content <- map["Content"];
         ordinal <- map["Ordinal"];
         thumbnail <- map["Thumbnail"];
         title <- map["Title"];
         created_at <- map["Created_at"];
         updated_at <- map["Updated_at"];
         
         created_at = created_at.replacingOccurrences(of: "T", with: " ")
         created_at = created_at.replacingOccurrences(of: "Z", with: "")
         
         updated_at = updated_at.replacingOccurrences(of: "T", with: " ")
         updated_at = updated_at.replacingOccurrences(of: "Z", with: "")
    }
}
