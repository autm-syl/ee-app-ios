//
//  CategoryNews.swift
//  ChichBong
//
//  Created by autm on 07/01/2022.
//

import ObjectMapper

class CategoryNewsResult: Mappable {
    var categories:[String] = []
    var message:String = ""
    init(){}
    required init?(map: Map) {
    }
   
     func mapping(map: Map) {
        categories <- map["Data"]
        message <- map["Message"]
    }
}
