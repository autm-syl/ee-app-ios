//
//  Quest.swift
//  ChichBong
//
//  Created by autm on 31/12/2021.
//

import ObjectMapper

class QuestsResult: Mappable {
    var data:QuestsData?
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         data <- map["Data"]
        message <- map["Message"]
    }
}

class QuestsData: Mappable {
    var total = 0;
    var quests:[QuestsObj] = [];
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         total <- map["total"];
         quests <- map["data"];
         
    }
}


class QuestsObj: Mappable {
    var Id = 0;
    var Question_category_id:Int?
    var Content = ""
    var Option1 = ""
    var Option2 = ""
    var Option3 = ""
    var Option4 = ""
    var Option5 = ""
    var Correct = ""
    var Hint = ""
    var Created_at = ""
    var Updated_at = ""
    
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         Id <- map["Id"];
         Question_category_id <- map["Question_category_id"];
         Content <- map["Content"];
         Option1 <- map["Option1"];
         Option2 <- map["Option2"];
         Option3 <- map["Option3"];
         Option4 <- map["Option4"];
         Option5 <- map["Option5"];
         Correct <- map["Correct"];
         Hint <- map["Hint"];
         Created_at <- map["Created_at"];
         Updated_at <- map["Updated_at"];
         
         Created_at = Created_at.replacingOccurrences(of: "T", with: " ")
         Created_at = Created_at.replacingOccurrences(of: "Z", with: "")
         
         Updated_at = Updated_at.replacingOccurrences(of: "T", with: " ")
         Updated_at = Updated_at.replacingOccurrences(of: "Z", with: "")
    }
}
