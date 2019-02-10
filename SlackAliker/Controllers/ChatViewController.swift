//
//  ChatViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var burgerButton: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        burgerButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.onChannelSelected), name: NOTIFICATION_CHANNEL_SELECTED, object: nil)
        
        getInitialUserData()
    }
    
    func getInitialUserData() {
        if AuthService.instance.isUserLoggedIn {
            AuthService.instance.getUserDataByEmail { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                }
            }
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func userDataDidChange() {
        if AuthService.instance.isUserLoggedIn {
            getMessagesAfterLogin()
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func onChannelSelected() {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessagesService.instance.selectedChannel!.channelTitle ?? "Chat"
        channelNameLbl.text = "#\(channelName)"
    }
    
    func getMessagesAfterLogin() {
        MessagesService.instance.findAllChannels { (success) in
            if success {
                //change
            }
        }
    }
    
    
}
