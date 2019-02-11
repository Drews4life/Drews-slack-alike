//
//  MessageCell.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/11/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var messageBodyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message) {
        usernameLbl.text = message.username
        messageBodyLbl.text = message.message
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.getUIColor(fromString: message.userAvatarColor)
        
        guard let isoDateIncorrect = message.timeStamp else { return }
        let end = isoDateIncorrect.index(isoDateIncorrect.endIndex, offsetBy: -5)
        let isoDate = isoDateIncorrect.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)
            timestampLbl.text = finalDate
        }
    }
}
