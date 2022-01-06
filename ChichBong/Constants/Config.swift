//
//  Config.swift
//  ChichBong
//
//  Created by Sylvanas on 3/31/21.
//

import Foundation
struct Config {
//    static let BASE_URL : String = "http://3.16.29.132:8088"
    static let BASE_URL : String = "http://192.168.1.4:8088"
    static let BASE_DOCUEMNT_VIEW : String = "http://3.16.29.132/document-view"
    

    static let APP_VERSION :String = "1.0.0"
    
    static let THIRTPT_BASE_URL : String = "https://chichbong.net";
    
    
    static let PATH_CONTACT_US : String = "/autm/static/contac_us"
    static let PATH_ABOUT_US : String = "/autm/static/about_us"
    static let PATH_TERM_CONDITION : String = "/autm/static/term_conditions"
    static let PATH_POLICY : String = "/autm/static/policies"
    
    static let CHAT_DOMAIN :String = "http://kiss.chichbong.vn"
}

enum NetworkErrorType {
    case API_ERROR
    case HTTP_ERROR
}

