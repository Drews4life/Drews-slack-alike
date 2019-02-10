//
//  ChannelViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width * 0.85;
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForUserData()
    }
    
    @IBAction func addChannelClick(_ sender: Any) {
        if AuthService.instance.isUserLoggedIn {
            let addChannel = AddChannelViewController()
            
            addChannel.modalPresentationStyle = .custom;
            present(addChannel, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        if AuthService.instance.isUserLoggedIn {
            let profile = ProfileViewController()
            
            profile.modalPresentationStyle = .custom;
            present(profile, animated: true, completion: nil);
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: self)
        }
    }
    
    @objc func userDataDidChange(_ notification: Notification) {
        checkForUserData()
    }
    
    func checkForUserData() {
        if AuthService.instance.isUserLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.getUIColor(fromString: nil)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon");
            userImg.backgroundColor = UIColor.clear;
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesService.instance.channels.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell else { return ChannelCell() }
        
        cell.configureCell(channel: MessagesService.instance.channels[indexPath.row])
        
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessagesService.instance.channels[indexPath.row];
        MessagesService.instance.selectedChannel = channel;
        
        NotificationCenter.default.post(name: NOTIFICATION_CHANNEL_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
}
