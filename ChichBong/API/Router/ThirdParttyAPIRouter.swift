//
//  ThirdParttyAPIRouter.swift
//  ChichBong
//
//  Created by autm on 18/06/2021.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

enum ThirdParttyAPIRouter: URLRequestConvertible {
    // =========== Begin define api ===========
    case sendComment(cm: String, fb_id: String, name: String, picture: String, phone: String)
    
    
    // =========== End define api ===========
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .sendComment:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .sendComment:
                return "/3rd/CommentFromApp"
        }
    }
    
    
    // MARK: - Headers
    private var headers: HTTPHeaders {
        //        ,"Access-Control-Allow-Origin":"*"
        let header: HTTPHeaders = ["Content-Type": "application/json"];
        return header;
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
            
        case .sendComment(let cm, let fb_id, let name, let picture, let phone) :
            return [
                "message": cm,
                "fb_id": fb_id,
                "name": name,
                "phone": phone,
                "picture": picture
            ]
        }
    }
    
    
    // MARK: - URL request
    func asURLRequest() throws -> URLRequest {
//        let url = try
        // setting path
        let URLString = try! URL(string: "\(Config.THIRTPT_BASE_URL)\(path)")!.asURL()
        print(URLString)
      
        var urlRequest: URLRequest = URLRequest(url: URLString)
        
        // setting method
        urlRequest.httpMethod = method.rawValue
        
        
        // setting header
        
        urlRequest.headers = headers;
//        for (key, value) in headers {
//            urlRequest.addValue(value, forHTTPHeaderField: key)
//        }
        if let parameters = parameters {
            do {
                
                if  (method.rawValue == "GET") || (method.rawValue == "DELETE")
                {
                    
                    urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
                    
                } else {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
                
                
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
    
    private func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

