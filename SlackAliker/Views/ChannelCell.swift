//
//  ChannelCell.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/10/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet fileprivate weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        channelName.text = "#\(channel.channelTitle ?? " ")"
        channelName.font = UIFont(name: "Avenir", size: 15)
        
        for id in MessagesService.instance.unreadChannels {
            if id == channel.id {
                channelName.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
    }

}
