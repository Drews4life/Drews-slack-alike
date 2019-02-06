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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width * 0.85;
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
