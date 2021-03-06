//
//  AuthService.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/7/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isUserLoggedIn: Bool {
        get {
            return defaults.bool(forKey: IS_LOGGED_IN)
        }
        set {
            defaults.set(newValue, forKey: IS_LOGGED_IN)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    /*
     
     IF YOU TRY TO LOGIN OR REGISTER AND NOTHING HAPPENS, IT MEANS MY HEROKU SERVER IS
     EITHER DOWN OR 'WAKING UP' FROM THE SLEEP. DOC SAYS WITH MY ACCOUNT IT MIGHT TAKE
     15-30 MINUTES FOR SERVER TO 'WAKE UP' KEEP THAT IN MIND
     
     */
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let emailLowerCased = email.lowercased()
        
        let body: [String: Any] = [
            "email": emailLowerCased,
            "password": password
        ]
        
        Alamofire.request(URL_ACCOUNT_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADERS).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let emailLowerCased = email.lowercased()
        
        let body: [String: Any] = [
            "email": emailLowerCased,
            "password": password
        ]
        
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADERS).responseJSON { (response) in
            if response.result.error == nil {
//
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let emailFromResponse = json["user"] as? String {
//                        self.userEmail = emailFromResponse;
//                    }
//
//                    if let token = json["token"] as? String {
//                        self.authToken = token;
//                    }
//                }
                guard let data = response.data else { return }
                let json = JSON(data: data)
                
                self.userEmail = json["user"].stringValue;
                self.authToken = json["token"].stringValue;
                self.isUserLoggedIn = true;
                
                completion(true)
            } else {
                completion(false)
                
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let emailLowerCased = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": emailLowerCased,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
       
        
        Alamofire.request(URL_CREATE_USER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: AUTH_HEADERS).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                self.setUserData(data: data)
                completion(true)
            } else {
                completion(false)
                
            }
            
        }
    }
    
    func getUserDataByEmail(completion: @escaping CompletionHandler) {
       
        Alamofire.request("\(URL_GET_USER_BY_EMAIL)\(self.userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: AUTH_HEADERS).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                self.setUserData(data: data)
                completion(true)
            } else {
                
                completion(false)
            }
        }
    }
    
    func setUserData(data: Data) {
        let json = JSON(data: data)
        
        let id = json["_id"].stringValue
        let color = json["avatarColor"].stringValue;
        let avatarName = json["avatarName"].stringValue;
        let email = json["email"].stringValue;
        let name = json["name"].stringValue;
        
        UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
    }
}
