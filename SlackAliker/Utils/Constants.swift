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

//USER DEFAULTS
let IS_LOGGED_IN = "isLoggedIn"
let TOKEN = "token"
let USER_EMAIL = "user_email"

//URLS
let BASE_URL = "https://drewschatter.herokuapp.com/v1/"
let URL_ACCOUNT_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"

//HEADERS
let HEADERS = [
    "Content-Type": "application/json; chatset=utf-8"
]
