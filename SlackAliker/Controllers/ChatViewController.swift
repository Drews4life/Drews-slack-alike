//
//  ChatViewController.swift
//  SlackAliker
//
//  Created by Andrii Zakharenkov on 2/6/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var burgerButton: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var userIsTypingLbl: UILabel!
    
    var isTyping = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        sendMessageBtn.isHidden = true;
        
        burgerButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        setupTableView()
        setupGestureRecognizers()
        setupObservers()
        setupInitialSocketsConnections()
        getInitialUserData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendMessageClick(_ sender: Any) {
        if AuthService.instance.isUserLoggedIn {
            guard let messageBody = messageInput.text, messageInput.text != "" else { return }
            guard let channelId = MessagesService.instance.selectedChannel?.id else { return }
            
            SocketService.instance.sendMessage(messageBody: messageBody, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageInput.text = ""
                    self.messageInput.resignFirstResponder()
                    SocketService.instance.socket.emit(STOP_TYPE, UserDataService.instance.name, channelId)
                }
            }
        }
    }
    
    func setupTableView() {
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableView.automaticDimension;
    }
    
    func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.onChannelSelected), name: NOTIFICATION_CHANNEL_SELECTED, object: nil)
    }
    
    func setupInitialSocketsConnections() {
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessagesService.instance.selectedChannel?.id && AuthService.instance.isUserLoggedIn {
                MessagesService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                
                if MessagesService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessagesService.instance.messages.count - 1, section: 0)
                    
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
                }
            }
        }
//        SocketService.instance.getChatMessage { (success) in
//            if success {
//                self.tableView.reloadData()
//                if MessagesService.instance.messages.count > 0 {
//                    let endIndex = IndexPath(row: MessagesService.instance.messages.count - 1, section: 0)
//
//                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
//                }
//            }
//        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessagesService.instance.selectedChannel?.id else { return }
            var names = ""
            var numOfTypingPeople = 0
            
            for (typingUser, channel) in typingUsers {
                if channel == channelId && typingUser != UserDataService.instance.name {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    
                    numOfTypingPeople += 1
                }
            }
            
            if numOfTypingPeople > 0 && AuthService.instance.isUserLoggedIn {
                let verb = numOfTypingPeople == 1 ? "is" : "are"
                self.userIsTypingLbl.text = "\(names) \(verb) typing..."
            } else {
                self.userIsTypingLbl.text = ""
            }
            
        }
    }
    
    func getInitialUserData() {
        if AuthService.instance.isUserLoggedIn {
            AuthService.instance.getUserDataByEmail { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                }
            }
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func userDataDidChange() {
        if AuthService.instance.isUserLoggedIn {
            getMessagesAfterLogin()
        } else {
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    @objc func onChannelSelected() {
        updateWithChannel()
    }
    @IBAction func messageEditingChange(_ sender: Any) {
        guard let channelId = MessagesService.instance.selectedChannel?.id else { return }
        
        if messageInput.text == "" {
            isTyping = false
            sendMessageBtn.isHidden = true
            SocketService.instance.socket.emit(STOP_TYPE, UserDataService.instance.name, channelId)
        } else {
            if !isTyping {
                sendMessageBtn.isHidden = false
            }
            isTyping = true;
            SocketService.instance.socket.emit(START_TYPE, UserDataService.instance.name, channelId)
        }
    }
    
    func updateWithChannel() {
        let channelName = MessagesService.instance.selectedChannel!.channelTitle ?? "Chat"
        channelNameLbl.text = "#\(channelName)"
        getRequestMessages()
    }
    
    func getMessagesAfterLogin() {
        MessagesService.instance.findAllChannels { (success) in
            if success {
                if MessagesService.instance.channels.count > 0 {
                    MessagesService.instance.selectedChannel = MessagesService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channel selected!"
                }
            }
        }
    }
    
    func getRequestMessages() {
        guard let channelId = MessagesService.instance.selectedChannel?.id else { return }
        
        MessagesService.instance.getAllMessagesForChannel(channelId: channelId, completion: { (success) in
            if success {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesService.instance.messages.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell else { return MessageCell() }
        
        cell.configureCell(message: MessagesService.instance.messages[indexPath.row])
        return cell;
    }
    
    
}
