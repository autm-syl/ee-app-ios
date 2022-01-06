//
//  Login.swift
//  ChichBong
//
//  Created by autm on 23/12/2021.
//

import Foundation
import ObjectMapper

class UserResult: Mappable {
    var user:UserObj?
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         user <- map["Data"]
        message <- map["Message"]
    }
}

class UserObj: Mappable {
    var Id = 0;
    var Username = "";
    var Mail = "";
    var Is_active = 0;
    var Avatar = "";
    var Name = "";
    var Fullname = "";
    var Department = "";
    var Address = "";
    var Phone = "";
    var Birthday = "";
    var Role = 0;
    var Extension = "";
    var Created_at = "";
    var Updated_at = "";
    var Token = "";
    
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
         Id <- map["Id"];
         Username <- map["Username"];
         Mail <- map["Mail"];
         Is_active <- map["Is_active"];
         Avatar <- map["Avatar"];
         Name <- map["Name"];
         Fullname <- map["Fullname"];
         Department <- map["Department"];
         Address <- map["Address"];
         Phone <- map["Phone"];
         Birthday <- map["Birthday"];
         Role <- map["Role"];
         Extension <- map["Extension"];
         Created_at <- map["Created_at"];
         Updated_at <- map["Updated_at"];
         Token <- map["Token"];
    }
}
