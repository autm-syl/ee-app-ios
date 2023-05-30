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
    case updateProfile(user_id: Int, mail: String, avatar: String, name: String, fullname: String, department: String, address: String, phone: String, birthday: String)
    case updatePassword(password: String, user_id: Int)
    case logout(deviceToken: String)
    case getAllCategory
    case getAllDocumentation(documentType: Int, pageSize:Int, pageIndex
                             :Int, nameQuery:String, status:Int)
    case createNewQA(name:String, content:String)
    case createCaseStudy(name:String, content:String)
    case getAllQuestCategories
    case getAllQuestLevel
    case getQuestsByCategoryId(_ categoryId: Int)
    case getQuestsByLevel(_ level: Int)
    case use_app(duration: Int)
    case user_watch(objectId: Int, watch_type: Int)
    case get_all_news(category_name: String)
    case getAllNewsCategories
    case uploadFile(typeFile: String)
    case searchDocument(key: String, documentType: Int)
    
    // =========== End define api ===========
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .me, .getAllCategory, .getAllDocumentation, .getAllQuestCategories, .getAllQuestLevel, .getQuestsByCategoryId, .getQuestsByLevel, .get_all_news, .getAllNewsCategories, .searchDocument:
            return .get
        case .registerUser, .login, .logout, .createNewQA, .createCaseStudy, .use_app, .user_watch, .uploadFile:
            return .post
        case .updateProfile, .updatePassword:
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
        case .updateProfile, .updatePassword:
            return "/autmAPI/account/update"
        case .logout:
            return "/autmAPI/account/login"
        case .getAllCategory:
            return "/autmAPI/category/mobile/all_category"
        case .getAllDocumentation(let documentType,let pageSize,let pageIndex,let nameQuery,let status):
            return "/autmAPI/documentation/get_document?pageSize=\(pageSize)&pageIndex=\(pageIndex)&type=\(documentType)&status=\(status)&nameQuery=\(nameQuery)"
        case .createNewQA, .createCaseStudy:
            return "/autmAPI/mobile/documentation/create"
        case .getAllQuestCategories:
            return "/autmAPI/question/category/for_mobile/get_all"
        case .getAllQuestLevel:
            return "/autmAPI/question/level/for_mobile/get_all"
        case .getQuestsByCategoryId(let categoryId):
            return "/autmAPI/question/paginate/mobile?pageSize=-1&pageIndex=-1&cateId=\(categoryId)"
        case .getQuestsByLevel(let level):
            return "/autmAPI/question/paginate/mobile/bylevel?pageSize=-1&pageIndex=-1&level=\(level)"
        case .use_app:
            return "/autmAPI/tracking/use_app"
        case .user_watch:
            return "/autmAPI/tracking/user_watch"
        case .get_all_news(let category_name):
            return "/autmAPI/news/get_news?category_name=\(category_name)"
        case .getAllNewsCategories:
            return "/autmAPI/news/categories"
        case .uploadFile(let typeFile):
            return "/autmAPI/upload?minetype=\(typeFile)"
        case .searchDocument(let key, let documentType):
            return "/autmAPI/elastic/search?key=\(key)&doctype=\(documentType)"
        }
    }
    
    
    // MARK: - Headers
    private var headers: HTTPHeaders {
        //        ,"Access-Control-Allow-Origin":"*"
        var header: HTTPHeaders = ["Content-Type": "application/json"];
        
        
        switch self {
        case  .registerUser, .login, .getAllCategory, .getQuestsByCategoryId, .getQuestsByLevel, .get_all_news, .getAllNewsCategories:
            break
        case .me, .updateProfile, .updatePassword, .logout, .getAllDocumentation, .createNewQA, .createCaseStudy, .getAllQuestCategories, .getAllQuestLevel, .use_app, .user_watch, .uploadFile:
            header.add(name: "Authorization", value: getAuthorizationHeader()!)
            break
        case .searchDocument:
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
        case .createCaseStudy(let name, let content):
            return [
                "Name": name,
                "Content": content,
                "Doc_type": DocumentType.CaseStudy
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
        case .updateProfile(let user_id, let mail, let avatar, let name, let fullname, let department, let address, let phone, let  birthday):
            var param : Parameters = [:]
            
            param["Id"] = user_id
            
            if mail != "" {
                param["Mail"] = mail
            }
            if avatar != "" {
                param["Avatar"] = avatar
            }
            if name != "" {
                param["Name"] = name
            }
            if fullname != "" {
                param["Fullname"] = fullname
            }
            if department != "" {
                param["Department"] = department
            }
            if address != "" {
                param["Address"] = address
            }
            if phone != "" {
                param["Phone"] = phone
            }
            if birthday != "" {
                param["Birthday"] = birthday
            }
           
            return param
        case .updatePassword(let password, let user_id):
            return [
                "Id": user_id,
                "Pass": password
            ]
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
