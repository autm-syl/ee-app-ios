//
//  QuestCategory.swift
//  ChichBong
//
//  Created by autm on 31/12/2021.
//

import ObjectMapper

class QuestCategoryResult: Mappable {
    var categories:[QuestCategory] = []
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         categories <- map["Data"]
        message <- map["Message"]
    }
}

class QuestCategory: Mappable {
    var id = 0;
    var name = "";
    var created_at = "";
    var updated_at = "";
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         id <- map["Id"];
         name <- map["Name"];
         created_at <- map["Created_at"];
         updated_at <- map["Updated_at"];
    }
}
