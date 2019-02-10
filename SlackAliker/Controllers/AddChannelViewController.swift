//
//  AddChannelViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/10/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class AddChannelViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelNameInput: UITextField!
    @IBOutlet weak var channelDescriptionInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    @IBAction func closeModalClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelClick(_ sender: Any) {
        guard let channelName = channelNameInput.text, channelNameInput.text != "" else { return }
        guard let channelDescription = channelDescriptionInput.text else { return }
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        channelNameInput.attributedPlaceholder = NSAttributedString(string: "Channel Name", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        channelDescriptionInput.attributedPlaceholder = NSAttributedString(string: "Channel Description", attributes: [NSAttributedString.Key.foregroundColor: purplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelViewController.closeTap))
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func closeTap() {
        dismiss(animated: true, completion: nil)
    }
}
