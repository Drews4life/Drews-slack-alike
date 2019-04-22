//
//  ProfileViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/9/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet fileprivate weak var profileImg: UIImageView!
    @IBOutlet fileprivate weak var usernameLbl: UILabel!
    @IBOutlet fileprivate weak var userEmailLbl: UILabel!
    @IBOutlet fileprivate weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupView() {
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.getUIColor(fromString: nil)
        usernameLbl.text = UserDataService.instance.name;
        userEmailLbl.text = UserDataService.instance.email;
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.closeTap))
        backgroundView.addGestureRecognizer(tap);
        
    }

    @IBAction fileprivate func closeModalClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction fileprivate func logoutClick(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func closeTap() {
        dismiss(animated: true, completion: nil)
    }
}
