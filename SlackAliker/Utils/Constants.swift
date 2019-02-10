//
//  Constants.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//NAVIGATION
let TO_LOGIN = "toLogin";
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_PICK_AVATAR = "toPickAvatar"

//USER DEFAULTS
let IS_LOGGED_IN = "isLoggedIn"
let TOKEN = "token"
let USER_EMAIL = "user_email"

//URLS
let BASE_URL = "https://drewschatter.herokuapp.com/v1/"
let URL_ACCOUNT_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_CREATE_USER = "\(BASE_URL)user/add"
let URL_GET_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel"

//SOCKET EVENTS
let NEW_CHANNEL = "newChannel"
let CHANNEL_CREATED = "channelCreated"

//HEADERS
let HEADERS = [
    "Content-Type": "application/json; chatset=utf-8"
]
let AUTH_HEADERS = [
    "Content-Type": "application/json; charset=utf-8",
    "Authorization": "Bearer \(AuthService.instance.authToken)"
]
//COLOR
let purplePlaceholder = #colorLiteral(red: 0.3266413212, green: 0.4215201139, blue: 0.7752227187, alpha: 0.5042273116)


//NOTIFICATION CONSTANTS
let NOTIFICATION_USER_DATA_DID_CHANGE = Notification.Name("notificationUserDataDidChange")
let NOTIFICATION_CHANNELS_LOADED = Notification.Name("notificationChannelsLoaded")
let NOTIFICATION_CHANNEL_SELECTED = Notification.Name("notificationChannelSelected")
