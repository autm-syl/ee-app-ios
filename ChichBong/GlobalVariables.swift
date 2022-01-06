//
//  GlobalVariables.swift
//  ChichBong
//
//  Created by Sylvanas on 3/31/21.
//

import Foundation
import UIKit
import CoreData
import OneSignal
import WebKit
import RealmSwift

class Globalvariables {
//    static var
    static let shareInstance = Globalvariables()
    
    var token_auth:String = "";
    var push_token:String = "";
    
    var user_name:String = ""; // not use login
    var avatar:String = "";

    var isFirstOpen:Bool = true;
    var thisUserID:Int = 0
    
    var activeStartTime:Double = 0
    

    var documentsLocal:Results<Documentation>?
    
    private init () {
        _ = ""
        //
        self.getTokenAuth();
        self.getUserName();
        self.getUserId()
        self.getAvatar();
        self.getAllLocalDocuments()
    }
    
    func getAllLocalDocuments() {
        let realm = try! Realm()
        
        let dogs = realm.objects(Documentation.self)
        documentsLocal = dogs
    }
    
    func saveDocument(doc: Documentation) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(doc, update: .modified)
        }
        
        let dogs = realm.objects(Documentation.self)
        documentsLocal = dogs
    }
    
    func removeDocument(doc: Documentation) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(doc)
        }
        
        let dogs = realm.objects(Documentation.self)
        documentsLocal = dogs
    }
    
    func clearAllData() {
        self.setTokenAuth(token: "");
        self.setUserName(username: "");
        self.setUserId(userId: 0);
        self.setAvatar(avatar: "");
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func checkFirstOpen() {
        if (UserDefaults.standard.value(forKey: "firstOpen") != nil) {
            let isFirst = UserDefaults.standard.value(forKey: "firstOpen") as? Bool;
            self.isFirstOpen = isFirst!;
        }
    }
    
    func setIsFirstOpen(isFirstOpen: Bool) {
        UserDefaults.standard.setValue(isFirstOpen, forKey: "firstOpen");
        UserDefaults.standard.synchronize();
        self.isFirstOpen = isFirstOpen
    }
    
    func setTokenAuth(token:String){
        UserDefaults.standard.setValue(token, forKey: "jwt");
        UserDefaults.standard.synchronize();
        self.token_auth = token;
    }
    
    func getTokenAuth() {
        let jwt = UserDefaults.standard.value(forKey: "jwt") as? String;
        self.token_auth = jwt ?? "";
    }
    
    func setUserName(username:String){
        UserDefaults.standard.setValue(username, forKey: "username");
        UserDefaults.standard.synchronize();
        self.user_name = username;
    }
    
    func getUserName() {
        let user_name = UserDefaults.standard.value(forKey: "username") as? String;
        self.user_name = user_name ?? "";
    }
    
    func setUserId(userId:Int){
        UserDefaults.standard.setValue(userId, forKey: "userId");
        UserDefaults.standard.synchronize();
        self.thisUserID = userId;
    }
    func getUserId() {
        if (UserDefaults.standard.value(forKey: "userId") != nil) {
            let user_id = UserDefaults.standard.value(forKey: "userId") as? Int;
            self.thisUserID = user_id!;
        } else {
            self.thisUserID = 0;
        }
        
    }
    
    func setAvatar(avatar:String){
        UserDefaults.standard.setValue(avatar, forKey: "avatar");
        UserDefaults.standard.synchronize();
        self.avatar = avatar;
    }
    func getAvatar() {
        let avatar = UserDefaults.standard.value(forKey: "avatar") as? String;
        self.avatar = avatar ?? "";
    }
}

extension Globalvariables {
    func sendAppUseDuration() {
        if (activeStartTime != 0) {
            let current = Date().timeIntervalSince1970
            let duration = current - self.activeStartTime
            self.activeStartTime = 0;
            
            MonConnection.requestCustom(APIRouter.use_app(duration: Int(duration))) { result, error in
                //
                // non handle
            }
        }
    }
    
    func sendUserWatch(objectId: Int, watch_type: Int) {
        MonConnection.requestCustom(APIRouter.user_watch(objectId: objectId, watch_type: watch_type)) { result, error in
            //
            // none handle
        }
    }
}
 
