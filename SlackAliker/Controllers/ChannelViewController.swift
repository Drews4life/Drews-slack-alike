//
//  ChannelViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width * 0.85;
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
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
        if AuthService.instance.isUserLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.getUIColor(fromString: nil)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon");
            userImg.backgroundColor = UIColor.clear;
        }
    }

}
