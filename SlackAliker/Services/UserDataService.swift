//
//  UserDataService.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/7/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
 
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id;
        self.avatarColor = color;
        self.avatarName = avatarName;
        self.email = email;
        self.name = name;
    }
    
    func changeAvatarName(avatarName: String) {
        self.avatarName = avatarName;
    }
}
