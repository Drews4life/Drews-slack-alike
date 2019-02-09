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
    
    func getUIColor(fromString color: String?) -> UIColor {
        
        let stringifiedColor = color ?? self.avatarColor;
        
        let scanner = Scanner(string: stringifiedColor)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped;
        
        var r, g, b, a: NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray;
        
        guard let unwrappedR = r else { return defaultColor }
        guard let unwrappedG = g else { return defaultColor }
        guard let unwrappedB = b else { return defaultColor }
        guard let unwrappedA = a else { return defaultColor }
        
        let floatR = CGFloat(unwrappedR.doubleValue)
        let floatG = CGFloat(unwrappedG.doubleValue)
        let floatB = CGFloat(unwrappedB.doubleValue)
        let floatA = CGFloat(unwrappedA.doubleValue)
        
        return UIColor(red: floatR, green: floatG, blue: floatB, alpha: floatA);
    }
    
    func logoutUser() {
        self.id = ""
        self.name = ""
        self.email = ""
        self.avatarColor = ""
        self.avatarName = ""
        AuthService.instance.isUserLoggedIn = false;
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        
    }
}
