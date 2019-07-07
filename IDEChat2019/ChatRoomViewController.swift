//
//  ChatRoomViewController.swift
//  IDEChat2019
//
//  Created by mohamed gamal mohamed on 6/17/19.
//  Copyright © 2019 mohamed gamal mohamed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class ChatRoomViewController: UIViewController {
    var room = Room()

    @IBOutlet weak var messageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = room.roomName
       // print("username is \(self.getUsername(compeletion: () -> ()))")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressOnSend(_ sender: UIButton) {
        if let message = messageTextField.text, message.isEmpty == false{
            getUsername { (username) in
                print("user is \(username)")
                self.sendMessage(message: message, user: username)

            }
        }
    }
    
    func sendMessage(message : String, user : String){
        let data : [String:String] = ["text": message, "user":user]
        let database = Database.database().reference()
        database.child("Rooms").child(room.roomID!).child("Messages").childByAutoId().setValue(data)
    }
    func getUsername(compeletion:@escaping (String) -> ()){
       if let currentUserId = Auth.auth().currentUser?.uid{
            let database = Database.database().reference()
        database.child("Users").child(currentUserId).child("username").observeSingleEvent(of: .value) { (response) in
            if let username = response.value as? String {
               // print(username)
                compeletion(username)
            }
            
        }
        }
    }

}
