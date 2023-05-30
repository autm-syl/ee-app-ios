//
//  UploadImage.swift
//  ChichBong
//
//  Created by autm on 10/01/2022.
//

import ObjectMapper

class UploadImageResult: Mappable {
  var Message:String = ""
  var Data:String = ""
  
  init(){}
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
      Message <-  map["Message"]
      Data <-  map["Data"]
 }
}

