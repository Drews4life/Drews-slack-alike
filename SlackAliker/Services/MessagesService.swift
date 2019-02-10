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
    
    func clearChannels() {
        self.channels.removeAll()
    }
}
