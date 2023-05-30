//
//  Config.swift
//  ChichBong
//
//  Created by Sylvanas on 3/31/21.
//

import Foundation
struct Config {
    static let BASE_URL : String = "http://45.76.156.52:8088"
//    static let BASE_URL : String = "http://192.168.1.20:8088"
    static let BASE_DOCUEMNT_VIEW : String = "http://45.76.156.52/document-view"
    

    static let APP_VERSION :String = "1.0.0"
    
    static let THIRTPT_BASE_URL : String = "https://chichbong.net";
    
    
    static let BASE_URL_STATIC : String = "http://45.76.156.52"
    static let PATH_CONTACT_US : String = "/news-view/2"
    static let PATH_ABOUT_US : String = "/news-view/1"
    static let PATH_TERM_CONDITION : String = "/news-view/3"
    static let PATH_POLICY : String = "/news-view/4"
}

enum NetworkErrorType {
    case API_ERROR
    case HTTP_ERROR
}

