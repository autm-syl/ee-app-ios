//
//  LoginViewData.swift
//  ChichBong
//
//  Created by autm on 23/12/2021.
//

import Foundation

class LoginViewDataData: NSObject {

    func login(username:String, pass:String, completion: @escaping(UserObj?, BaseResponseError?) -> Void) {
        MonConnection.requestCustom(APIRouter.login(user_name: username, pass: pass)) { result, error in
            if error == nil {
                // xu ly result
                let login_result = UserResult.init(JSON: result!)
                
                if login_result?.message == "Success" && login_result!.user != nil {
                    completion(login_result!.user, nil)
                } else {
                    completion(nil, BaseResponseError.init(.API_ERROR, 40002, "Lỗi thông tin cá nhân"))
                }
                
                
            } else {
                completion(nil, error)
            }
        }
    }
    
    func register(username:String, pass:String, completion: @escaping(UserObj?, BaseResponseError?) -> Void) {
        MonConnection.requestCustom(APIRouter.registerUser(user_name: username, pass: pass)) { result, error in
            if error == nil {
                // xu ly result
                let login_result = UserResult.init(JSON: result!)
                
                if login_result?.message == "Success" && login_result!.user != nil {
                    completion(login_result!.user, nil)
                } else {
                    completion(nil, BaseResponseError.init(.API_ERROR, 40002, "Lỗi thông tin cá nhân"))
                }
                
                
            } else {
                completion(nil, error)
            }
        }
    }
}
