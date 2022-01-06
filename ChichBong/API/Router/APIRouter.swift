//
//  APIRouter.swift
//  ChichBong
//
//  Created by Sylvanas on 3/31/21.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

enum APIRouter: URLRequestConvertible {
    // =========== Begin define api ===========
    case registerUser(user_name:String, pass:String)
    case login(user_name:String, pass:String)
    case me
    case updateProfile(Adr1: String, Adr2: String, Birthday: String, Device_id: String, Device_name: String, Fb_id: String, Gender: Int, Name: String, Old: Int, Phone_num: String, User_name: String, Pass: String, User_location: String, Avatar: String)
    case logout(deviceToken: String)
    case getAllCategory
    case getAllDocumentation(documentType: Int, pageSize:Int, pageIndex
                             :Int, nameQuery:String, status:Int)
    case createNewQA(name:String, content:String)
    case getAllQuestCategories
    case getQuestsByCategoryId(_ categoryId: Int)
    case use_app(duration: Int)
    case user_watch(objectId: Int, watch_type: Int)
   
    // =========== End define api ===========
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .me, .getAllCategory, .getAllDocumentation, .getAllQuestCategories, .getQuestsByCategoryId:
            return .get
        case .registerUser, .login, .logout, .createNewQA, .use_app, .user_watch:
            return .post
        case .updateProfile:
            return .put
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .registerUser:
            return "/autmAPI/account/register"
        case .login:
            return "/autmAPI/account/login"
        case .me:
            return "/autmAPI/account/me"
        case .updateProfile:
            return "/autmAPI/account/update_profile"
        case .logout:
            return "/autmAPI/account/login"
        case .getAllCategory:
            return "/autmAPI/category/mobile/all_category"
        case .getAllDocumentation(let documentType,let pageSize,let pageIndex,let nameQuery,let status):
            return "/autmAPI/documentation/get_document?pageSize=\(pageSize)&pageIndex=\(pageIndex)&type=\(documentType)&status=\(status)&nameQuery=\(nameQuery)"
        case .createNewQA:
            return "/autmAPI/mobile/documentation/create"
        case .getAllQuestCategories:
            return "/autmAPI/question/category/get_all"
        case .getQuestsByCategoryId(let categoryId):
            return "/autmAPI/question/paginate/mobile?pageSize=-1&pageIndex=-1&cateId=\(categoryId)"
        case .use_app:
            return "/autmAPI/tracking/use_app"
        case .user_watch:
            return "/autmAPI/tracking/user_watch"
        }
    }
    
    
    // MARK: - Headers
    private var headers: HTTPHeaders {
        //        ,"Access-Control-Allow-Origin":"*"
        var header: HTTPHeaders = ["Content-Type": "application/json"];
            
        
        switch self {
        case  .registerUser, .login, .getAllCategory, .getQuestsByCategoryId:
            break
        case .me, .updateProfile, .logout, .getAllDocumentation, .createNewQA, .getAllQuestCategories, .use_app, .user_watch:
            header.add(name: "Authorization", value: getAuthorizationHeader()!)
            break
        }
        return header;
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
            
        case .registerUser(let user_name, let pass):
            return [
                "Pass":pass,
                "Username":user_name
            ]
        case .login(let user_name, let pass):
            return [
                "Password":pass,
                "Username":user_name
            ]
        case .me:
            return [:]
        case .logout(let deviceToken):
            return [
                "device_id": deviceToken
            ]
        case .createNewQA(let name, let content):
            return [
                "Name": name,
                "Content": content,
                "Doc_type": DocumentType.QA
            ]
        case .use_app(let duration):
            return [
                "Time_use": duration,
                "Device_type": 1
            ]
        case .user_watch(let objectId, let watch_type):
            switch watch_type {
            case 1:
                //watch document
                return [
                    "Watch_type": watch_type,
                    "Documentation_id": objectId,
                    "Device_type": 1
                ]
            case 2:
                //watch category
                return [
                    "Watch_type": watch_type,
                    "Category_id": objectId,
                    "Device_type": 1
                ]
            default:
                return [
                    "Watch_type": watch_type,
                    "Documentation_id": objectId,
                    "Category_id": objectId,
                    "Device_type": 1
                ]
            }
            
        default :
            return [:]
        
        }
    }
    
    
    // MARK: - URL request
    func asURLRequest() throws -> URLRequest {
        let URLString = try! URL(string: "\(Config.BASE_URL)\(path)")!.asURL()
        print(URLString)
      
        var urlRequest: URLRequest = URLRequest(url: URLString)
        
        // setting method
        urlRequest.httpMethod = method.rawValue
        
        
        // setting header
        
        urlRequest.headers = headers;
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
    
    private func getAuthorizationHeader() -> String? {
        let token = "Bearer \(Globalvariables.shareInstance.token_auth)"
        
        return token
    }
    
    private func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
