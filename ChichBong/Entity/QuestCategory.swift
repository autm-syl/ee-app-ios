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
    var level = -1;
    var total_quest = 0;
    var created_at = "";
    var updated_at = "";
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         id <- map["Id"];
         name <- map["Name"];
         total_quest <- map["Total_quest"];
         created_at <- map["Created_at"];
         updated_at <- map["Updated_at"];
         
         created_at = created_at.replacingOccurrences(of: "T", with: " ")
         created_at = created_at.replacingOccurrences(of: "Z", with: "")
         
         updated_at = updated_at.replacingOccurrences(of: "T", with: " ")
         updated_at = updated_at.replacingOccurrences(of: "Z", with: "")
    }
}

class QuestLevelResult: Mappable {
    var levels:[QuestLevel] = []
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         levels <- map["Data"]
         message <- map["Message"]
    }
}

class QuestLevel: Mappable {
    var level_quest = 0;
    var total_quest = 0;
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         level_quest <- map["Level_quest"];
         total_quest <- map["Total_quest"];
    }
}
