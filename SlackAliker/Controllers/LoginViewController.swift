//
//  LoginViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        guard let email = emailInput.text, emailInput.text != "" else { return }
        guard let password = passwordInput.text, passwordInput.text != "" else { return }
        
        loadingIndicator.isHidden = false;
        loadingIndicator.startAnimating();
        
        debugPrint("Email we provided from input: ", email)
        
        AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
            if success {
                AuthService.instance.getUserDataByEmail(completion: { (success) in
                    
                    self.loadingIndicator.isHidden = true;
                    self.loadingIndicator.stopAnimating();
                    
                    if success {
                        NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                print("FAILED THERE BOY")
                self.loadingIndicator.isHidden = true;
                self.loadingIndicator.stopAnimating();
            }
        })
    }
    @IBAction func dismissClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateAccountClick(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: self)
    }
   
    func setupView() {
        loadingIndicator.isHidden = true;
        
        emailInput.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        passwordInput.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
    }

}
