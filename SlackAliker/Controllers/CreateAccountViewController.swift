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
    
    let avatarName = "profileDefault"
    let avatarColor = "[0.5, 0.5, 0.5, 1]";
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func createAccountClick(_ sender: Any) {
        guard let name = usernameInput.text, usernameInput.text != "" else { return }
        guard let email = emailInput.text, emailInput.text != "" else { return }
        guard let password = passwordInput.text, passwordInput.text != "" else { return }
        
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
                            if success {
                                self.performSegue(withIdentifier: UNWIND, sender: self)
                            }
                        })
                        
                    }
                })
            }
        }
    }
    
    
    @IBAction func chooseAvatarClick(_ sender: Any) {
        
    }
    
    @IBAction func generateRandomBackgroundClick(_ sender: Any) {
        
    }
    
    
    @IBAction func dismissAllClick(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: self)
    }
    
}
