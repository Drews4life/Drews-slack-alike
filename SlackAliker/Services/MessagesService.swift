//
//  MessagesService.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/10/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessagesService {
    static let instance = MessagesService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel: Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: AUTH_HEADERS).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
//                do {
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                } catch let error {
//                    debugPrint(error as Any)
//                }
                
                if let json = JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    //NotificationCenter.default.post(name: NOTIFICATION_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
                
            } else {
                debugPrint("error exists: ",response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func getAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)/\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: AUTH_HEADERS).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.clearMessages()
                debugPrint("-----SUCCEDED TO FETCH MESSAGES----")
                if let json = JSON(data: data).array {
                    debugPrint("JSON MESSAGES DATA------: ", json)
                    for item in json {
                        let id = item["_id"].stringValue
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let username = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        //let userId = item["userId"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        //deleted --> userId: userId, from args
                        let message = Message(message: messageBody, username: username, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        debugPrint("-----SUCCEDED TO STORE MESSAGES----")
                        self.messages.append(message)
                    }
                    completion(true)
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        self.messages.removeAll()
    }
    
    func clearChannels() {
        self.channels.removeAll()
    }
}
