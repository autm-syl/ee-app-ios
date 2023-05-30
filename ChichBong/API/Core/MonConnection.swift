//
//  MonConnection.swift
//  ChichBong
//
//  Created by Sylvanas on 3/31/21.
//

import Foundation


import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyJSON
import SVProgressHUD;
import Toast_Swift

class MonConnection {
    
    static func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func request<T: Mappable>(_ apiRouter: APIRouter,_ returnType: T.Type, completion: @escaping (_ result: [T]?, _ error: BaseResponseError?) -> Void) {
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            //            ShowBottomToastWith(title: "Có vẻ như kết nối mạng có sự cố.\nVui lòng kiểm tra kết nối mạng và thử lại", messColor: UIColor.red)
            SVProgressHUD.dismiss();
            return
        }
        
        AF.request(apiRouter).responseObject {(response: AFDataResponse<BaseResponse<T>>) in
            switch response.result {
            case .success:
                print(response.result)
                if response.response?.statusCode == 200 {
                    if (response.value!.isSuccessCode())! {
                        completion((response.value?.result)!, nil)
                        
                    } else {
                        let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.API_ERROR, (response.value?.code)!, (response.value?.error)!)
                        completion(nil, err)
                    }
                }
                else if response.response?.statusCode == 401 {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, (response.response?.statusCode)!, "(Request is error!)")
                    print("error 401 authen ")
                    completion(nil, err)
                    
                }
                else {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, (response.response?.statusCode)!, "(Request is error!)")
                    completion(nil, err)
                }
                break
                
            case .failure(let error):
                if error is AFError {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, error._code, "Request is error!")
                    completion(nil, err)
                }
                print(response)
                break
            }
        }
        
        
        
    }
    
    static func requestObject<T: Mappable>(_ apiRouter: APIRouter,_ returnType: T.Type, completion: @escaping (_ result: T?, _ error: BaseResponseError?) -> Void) {
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            ShowBottomToastWith(title: "Có vẻ như kết nối mạng có sự cố.\nVui lòng kiểm tra kết nối mạng và thử lại", messColor: UIColor.red)
            return
        }
        
        AF.request(apiRouter).responseObject {(response: AFDataResponse<BaseObjectResponse<T>>) in
            switch response.result {
            case .success:
                if response.response?.statusCode == 200 {
                    if (response.value?.isSuccessCode())! {
                        completion((response.value?.result), nil)
                    } else {
                        let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.API_ERROR, (response.value?.code)!, (response.value?.error)!)
                        completion(nil, err)
                    }
                }
                else if response.response?.statusCode == 401 {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, (response.response?.statusCode)!, "(Authen!)")
                    completion(nil, err)
                }
                else {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, (response.response?.statusCode)!, "(Request is error!)")
                    completion(nil, err)
                }
                break
                
            case .failure(let error):
                if error is AFError {
                    print(response)
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, error._code, "Request is error!")
                    completion(nil, err)
                    
                    
                }
                
                break
            }
        }
        
        
        
    }
    
    static func requestCustom(_ apiRouter: APIRouter,completionHandler: @escaping (_ result: [String: Any]?, _ error: BaseResponseError?) -> Void) {
        
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            ShowBottomToastWith(title: "Có vẻ như kết nối mạng có sự cố.\nVui lòng kiểm tra kết nối mạng và thử lại", messColor: UIColor.red)
            
            let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, 000, "No internet access!")
            completionHandler(nil, err)
            return
        }
        
        AF.request(apiRouter).responseJSON(completionHandler: { (response: AFDataResponse<Any>) in
            switch response.result {
            case .success(let JSON):
                if response.response?.statusCode == 200 {
                    completionHandler((JSON as! [String : Any]), nil)
                } else if (response.response?.statusCode == 204){
                    completionHandler(nil, nil);
                } else if response.response?.statusCode == 401{
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, "Lỗi xác thực tài khoản!")
                    completionHandler(nil, err)
                    print("authen 401")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                        Globalvariables.shareInstance.clearAllData()
                        NotificationCenter.default.post(name:.goIntoIntroview, object: nil);
                    }
                }else{
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, "\(JSON)")
                    completionHandler(nil, err)
                    print(response)
                }
                break
            case .failure(let error):
                if (response.response != nil) {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, error.errorDescription!)
                    completionHandler(nil, err)
                } else {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, 404, error.errorDescription!)
                    completionHandler(nil, err)
                }
            }
        })
    }
    
    
    static func requestCustomThirdPt(_ apiRouter: ThirdParttyAPIRouter,completionHandler: @escaping (_ result: [String: Any]?, _ error: BaseResponseError?) -> Void) {
        
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            ShowBottomToastWith(title: "Có vẻ như kết nối mạng có sự cố.\nVui lòng kiểm tra kết nối mạng và thử lại", messColor: UIColor.red)
            
            let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, 000, "No internet access!")
            completionHandler(nil, err)
            return
        }
        
        AF.request(apiRouter).responseJSON(completionHandler: { (response: AFDataResponse<Any>) in
            switch response.result {
            case .success(let JSON):
                if response.response?.statusCode == 200 {
                    completionHandler((JSON as! [String : Any]), nil)
                } else if (response.response?.statusCode == 204){
                    completionHandler(nil, nil);
                } else if response.response?.statusCode == 401{
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, "Lỗi xác thực tài khoản!")
                    completionHandler(nil, err)
                    print("authen 401")
                }else{
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, "\(JSON)")
                    completionHandler(nil, err)
                    print(response)
                }
                break
            case .failure(let error):
                if (response.response != nil) {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, error.errorDescription!)
                    completionHandler(nil, err)
                } else {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, 404, error.errorDescription!)
                    completionHandler(nil, err)
                }
            }
        })
    }
    
    static func UploadVideoFile(fileURL: URL, completionHandler: @escaping (_ result: [String: Any]?, _ error: BaseResponseError?) -> Void) {
        
        
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            ShowBottomToastWith(title: "Có vẻ như kết nối mạng có sự cố.\nVui lòng kiểm tra kết nối mạng và thử lại", messColor: UIColor.red)
            
            let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, 000, "No internet access!")
            completionHandler(nil, err)
            return
        }
        
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileURL, withName: "file", fileName: "filename.MOV", mimeType: "video/MOV")
            //            multipartFormData.append(broadId.data(using: String.Encoding.utf8)!, withName: "board_id")
        }, with: APIRouter.uploadFile(typeFile: "video")).responseJSON { (response: AFDataResponse<Any>) in
            switch response.result {
            case .success(let JSON):
                if response.response?.statusCode == 200 {
                    completionHandler((JSON as! [String : Any]), nil)
                } else if (response.response?.statusCode == 204){
                    completionHandler(nil, nil);
                } else if response.response?.statusCode == 401{
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, "Lỗi xác thực tài khoản!")
                    completionHandler(nil, err)
                    print("authen 401")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                        Globalvariables.shareInstance.clearAllData()
                        NotificationCenter.default.post(name:.goIntoIntroview, object: nil);
                    }
                    
                }else{
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, "\(JSON)")
                    completionHandler(nil, err)
                    print(response)
                }
                break
            case .failure(let error):
                if (response.response != nil) {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, error.errorDescription!)
                    completionHandler(nil, err)
                } else {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, 404, error.errorDescription!)
                    completionHandler(nil, err)
                }
            }
        }
    }
    
    static func UploadImageFile(fileData: Data, completionHandler: @escaping (_ result: [String: Any]?, _ error: BaseResponseError?) -> Void) {
        
        
        if !isConnectedToInternet() {
            // Xử lý khi lỗi kết nối internet
            ShowBottomToastWith(title: "Có vẻ như kết nối mạng có sự cố.\nVui lòng kiểm tra kết nối mạng và thử lại", messColor: UIColor.red)
            
            let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, 000, "No internet access!")
            completionHandler(nil, err)
            return
        }
        
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "file", fileName: "filename.png", mimeType: "image/png")
            //            multipartFormData.append(broadId.data(using: String.Encoding.utf8)!, withName: "board_id")
        }, with: APIRouter.uploadFile(typeFile: "image")).responseJSON { (response: AFDataResponse<Any>) in
            switch response.result {
            case .success(let JSON):
                if response.response?.statusCode == 200 {
                    completionHandler((JSON as! [String : Any]), nil)
                } else if (response.response?.statusCode == 204){
                    completionHandler(nil, nil);
                } else if response.response?.statusCode == 401{
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, "Lỗi xác thực tài khoản!")
                    completionHandler(nil, err)
                    print("authen 401")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                        Globalvariables.shareInstance.clearAllData()
                        NotificationCenter.default.post(name:.goIntoIntroview, object: nil);
                    }
                }else{
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, "\(JSON)")
                    completionHandler(nil, err)
                    print(response)
                }
                break
            case .failure(let error):
                if (response.response != nil) {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, response.response!.statusCode, error.errorDescription!)
                    completionHandler(nil, err)
                } else {
                    let err: BaseResponseError = BaseResponseError.init(NetworkErrorType.HTTP_ERROR, 404, error.errorDescription!)
                    completionHandler(nil, err)
                }
            }
        }
    }
    
    static func ShowBottomToastWith(title: String, messColor: UIColor) {
        var style = ToastStyle()
        style.messageColor = messColor
        
        if let keyWindow = UIWindow.key {
            // Do something
            keyWindow.makeToast(title, duration: 10.0, position: .bottom, style: style)
            ToastManager.shared.isTapToDismissEnabled = true
            ToastManager.shared.isQueueEnabled = true
        }
    }
}


