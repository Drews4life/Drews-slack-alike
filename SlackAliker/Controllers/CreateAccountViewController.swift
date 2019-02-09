//
//  CreateAccountViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]";
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            avatarName = UserDataService.instance.avatarName;
            
            userImg.image = UIImage(named: avatarName)
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    
    @IBAction func createAccountClick(_ sender: Any) {
        guard let name = usernameInput.text, usernameInput.text != "" else { return }
        guard let email = emailInput.text, emailInput.text != "" else { return }
        guard let password = passwordInput.text, passwordInput.text != "" else { return }
        
        activitySpinner.isHidden = false;
        activitySpinner.startAnimating()
        
        /*
 
         IF YOU TRY TO LOGIN OR REGISTER AND NOTHING HAPPENS, IT MEANS MY HEROKU SERVER IS
         EITHER DOWN OR 'WAKING UP' FROM THE SLEEP. DOC SAYS WITH MY ACCOUNT IT MIGHT TAKE
         15-30 MINUTES FOR SERVER TO 'WAKE UP' KEEP THAT IN MIND
 
        */
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        //performSegue(withIdentifier: UNWIND, sender: nil)
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            
                            self.activitySpinner.isHidden = true;
                            self.activitySpinner.stopAnimating()
                            
                            if success {
                                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                                self.performSegue(withIdentifier: UNWIND, sender: self)
                            }
                        })
                        
                    } else {
                        self.activitySpinner.isHidden = true;
                        self.activitySpinner.stopAnimating()
                    }
                })
            } else {
                self.activitySpinner.isHidden = true;
                self.activitySpinner.stopAnimating()
            }
        }
    }
    
    
    
    @IBAction func chooseAvatarClick(_ sender: Any) {
        performSegue(withIdentifier: TO_PICK_AVATAR, sender: self)
    }
    
    @IBAction func generateRandomBackgroundClick(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        UIView.animate(withDuration: 0.2) {
            self.userImg.backgroundColor = self.bgColor;
        }
    }
    
    
    @IBAction func dismissAllClick(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: self)
    }
    
    func setupView() {
        activitySpinner.isHidden = true;
        
        usernameInput.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        emailInput.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        passwordInput.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
